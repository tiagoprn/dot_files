from unittest import mock, TestCase

from alarm import get_trigger_alarm_now

class TestGetTriggerAlarmNow(TestCase):

    def setUp(self):
        self.line1 = '- Iniciar testes @2019-08-25 19:50 @daily @-1h #testing'

    @mock.patch('alarm._get_current_timestamp')
    def test_should_trigger_alarm(self, mock_timestamp):
        mock_timestamp.return_value = '2019-07-01 19:50'
        result = get_trigger_alarm_now(self.line1)
        self.assertEqual(result, 'Iniciar testes')

    @mock.patch('alarm._get_current_timestamp')
    def test_should_not_trigger_alarm(self, mock_timestamp):
        mock_timestamp.return_value = '2019-07-01 19:49'
        result = get_trigger_alarm_now(self.line1)
        self.assertEqual(result, '')

