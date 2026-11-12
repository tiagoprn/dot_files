# /// script
# requires-python = ">=3.11"
# dependencies = []
# ///
"""Tests for harpoon.py. Run the whole file with `uv run test_harpoon.py`."""

import contextlib
import io
import os
import tempfile
import unittest
from pathlib import Path
from unittest import mock

import harpoon as h

OK_RUN = mock.Mock(returncode=0, stdout="", stderr="")


class PinsFileTests(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.path = Path(self.tmp.name) / "pins.txt"

    def test_read_missing_file_is_empty(self):
        self.assertEqual(h.read_pins(self.path), [])

    def test_read_skips_blanks_comments_and_whitespace(self):
        self.path.write_text("# c\n\n  alpha  \n beta\n   \n#c2\n", encoding="utf-8")
        self.assertEqual(h.read_pins(self.path), ["alpha", "beta"])

    def test_ensure_file_creates_parent_and_header(self):
        nested = Path(self.tmp.name) / "a" / "b" / "pins.txt"
        h.ensure_file(nested)
        self.assertTrue(nested.exists())
        self.assertIn("Ctrl+F1", nested.read_text(encoding="utf-8"))
        self.assertEqual(h.read_pins(nested), [])

    def test_ensure_file_never_overwrites(self):
        self.path.write_text("alpha\n", encoding="utf-8")
        h.ensure_file(self.path)
        self.assertEqual(h.read_pins(self.path), ["alpha"])


class KeyTests(unittest.TestCase):
    def test_slots_inside_the_bound_range(self):
        self.assertEqual(h.key_for(1), "Ctrl+F1")
        self.assertEqual(h.key_for(11), "Ctrl+F11")

    def test_slots_past_the_range_have_no_key(self):
        self.assertEqual(h.key_for(12), "no key")
        self.assertEqual(h.key_for(99), "no key")

    def test_slot_zero_is_not_bound(self):
        self.assertEqual(h.key_for(0), "no key")


class SeedOrderTests(unittest.TestCase):
    ROWS = "alpha|1|500|100\nbeta|0|900|100\ngamma|0|0|200\ndelta|0|0|200\n"

    def test_attached_leads_then_recent_attach_then_newest_then_name(self):
        names = h.seed_order(h.parse_sessions(self.ROWS))
        self.assertEqual(names, ["alpha", "beta", "delta", "gamma"])

    def test_empty_output_yields_no_names(self):
        self.assertEqual(h.seed_order(h.parse_sessions("")), [])

    def test_never_attached_sessions_sort_last(self):
        rows = "a|0||100\nb|0|999|100\n"
        self.assertEqual(h.seed_order(h.parse_sessions(rows)), ["b", "a"])

    def test_malformed_rows_are_dropped(self):
        rows = "good|1|10|5\nbroken row\n|0|0|0\ntwo|fields\n"
        self.assertEqual([s.name for s in h.parse_sessions(rows)], ["good"])


class JumpTests(unittest.TestCase):
    PINS = ("alpha", "beta", "gamma")

    def test_slot_resolves_to_its_line(self):
        self.assertEqual(h.resolve_jump(self.PINS, "2"), ("beta", ""))

    def test_last_resolves_to_the_final_entry(self):
        self.assertEqual(h.resolve_jump(self.PINS, "last"), ("gamma", ""))

    def test_missing_line_is_reported(self):
        session, message = h.resolve_jump(self.PINS, "9")
        self.assertIsNone(session)
        self.assertEqual(message, "no pin at line 9")

    def test_zero_is_not_a_slot(self):
        session, message = h.resolve_jump(self.PINS, "0")
        self.assertIsNone(session)
        self.assertEqual(message, "no pin at line 0")

    def test_junk_is_rejected(self):
        session, message = h.resolve_jump(self.PINS, "x")
        self.assertIsNone(session)
        self.assertEqual(message, "not a slot: x")

    def test_empty_list_asks_for_a_seed(self):
        session, message = h.resolve_jump([], "1")
        self.assertIsNone(session)
        self.assertIn("no pins yet", message)


class PinTests(unittest.TestCase):
    def test_absent_session_is_appended(self):
        pins, grows, message = h.pin_entry(["alpha"], "beta")
        self.assertEqual(pins, ["alpha", "beta"])
        self.assertTrue(grows)
        self.assertEqual(message, "pinned beta as 2 (Ctrl+F2)")

    def test_present_session_is_not_appended(self):
        pins, grows, message = h.pin_entry(["alpha", "beta"], "beta")
        self.assertEqual(pins, ["alpha", "beta"])
        self.assertFalse(grows)
        self.assertEqual(message, "already at line 2, Ctrl+F2")

    def test_present_session_past_the_bound_range_has_no_key(self):
        pins = [f"s{n}" for n in range(1, 12)] + ["tail"]
        _, grows, message = h.pin_entry(pins, "tail")
        self.assertFalse(grows)
        self.assertEqual(message, "already at line 12, no key")

    def test_input_list_is_not_mutated(self):
        original = ["alpha"]
        h.pin_entry(original, "beta")
        self.assertEqual(original, ["alpha"])


class EditTests(unittest.TestCase):
    def test_empty_list_seeds_from_live_sessions(self):
        self.assertEqual(h.seed_entries([], ["a", "b"]), (["a", "b"], True))

    def test_non_empty_list_is_left_alone(self):
        self.assertEqual(h.seed_entries(["mine"], ["a"]), (["mine"], False))

    def test_no_live_sessions_means_no_seed(self):
        self.assertEqual(h.seed_entries([], []), ([], False))


class EditCommandSeedingTests(unittest.TestCase):
    """Regression: edit must never reseed once the list holds entries."""

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.addCleanup(self.tmp.cleanup)
        self.path = Path(self.tmp.name) / "pins.txt"
        self.path.write_text("# header\n\nmine\n# kept\n", encoding="utf-8")

    def test_edit_keeps_a_non_empty_list_and_skips_seeding(self):
        with (
            mock.patch.object(h, "live_sessions", return_value=[]),
            mock.patch("subprocess.run", return_value=OK_RUN) as run,
        ):
            code = h.main(["--file", str(self.path), "edit"])
        self.assertEqual(code, 0)
        run.assert_called_once()
        self.assertIn("display-popup", run.call_args.args[0])
        self.assertEqual(
            h.read_pins(self.path), ["mine"]
        )  # entry preserved, no live session injected

    def test_edit_seeds_only_when_the_list_is_empty(self):
        empty = Path(self.tmp.name) / "empty.txt"
        with (
            mock.patch.object(
                h,
                "live_sessions",
                return_value=[
                    h.Session(name="b", attached=False, last_attached=9, created=1),
                    h.Session(name="a", attached=True, last_attached=0, created=2),
                ],
            ),
            mock.patch("subprocess.run", return_value=OK_RUN) as run,
        ):
            h.main(["--file", str(empty), "edit"])
        self.assertEqual(h.read_pins(empty), ["a", "b"])
        popups = [c for c in run.call_args_list if c.args[0][1] == "display-popup"]
        self.assertEqual(len(popups), 1)  # exactly one editor launch
        self.assertFalse(
            [c for c in run.call_args_list if c.args[0][1] == "switch-client"]
        )

    def test_edit_with_no_live_sessions_and_no_file_opens_an_empty_editor(self):
        empty = Path(self.tmp.name) / "none.txt"
        with (
            mock.patch.object(h, "live_sessions", return_value=[]),
            mock.patch("subprocess.run", return_value=OK_RUN) as run,
        ):
            code = h.main(["--file", str(empty), "edit"])
        self.assertEqual(code, 0)
        run.assert_called_once()
        self.assertIn("display-popup", run.call_args.args[0])
        self.assertEqual(h.read_pins(empty), [])


class StatePathTests(unittest.TestCase):
    """Tests must never resolve to the real pins file."""

    def test_default_is_under_home_state(self):
        with mock.patch.dict(os.environ, {}, clear=True):
            expected = Path.home() / ".local/state/tmux-harpoon/pins.txt"
            self.assertEqual(h.state_path(), expected)

    def test_xdg_state_home_is_honoured(self):
        with mock.patch.dict(os.environ, {"XDG_STATE_HOME": "/tmp/xdg"}, clear=True):
            self.assertEqual(h.state_path(), Path("/tmp/xdg/tmux-harpoon/pins.txt"))

    def test_explicit_override_wins(self):
        self.assertEqual(h.state_path("/tmp/x"), Path("/tmp/x"))

    def test_path_command_prints_the_resolved_file(self):
        buffer = io.StringIO()
        with contextlib.redirect_stdout(buffer):
            code = h.main(["--file", "/tmp/zz.txt", "path"])
        self.assertEqual(code, 0)
        self.assertEqual(buffer.getvalue().strip(), "/tmp/zz.txt")

    def test_path_command_creates_nothing(self):
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp) / "nested" / "pins.txt"
            with contextlib.redirect_stdout(io.StringIO()):
                h.main(["--file", str(target), "path"])
            self.assertFalse(target.exists())
            self.assertFalse(target.parent.exists())


if __name__ == "__main__":
    unittest.main()
