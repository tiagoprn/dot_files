#!/usr/bin/env python3

# Github: https://framagit.org/Daguhh/rofitranspose

"""
USAGE:

echo <elements line by line> | ./from_file.py --columns <number of columns> | rofi -dmenu -columns <number of columns -lines <number of lines>

E.g.

printf " 1-1 \n 2-1 \n 3-1 \n 4-1 \n 1-2 \n 2-2 \n 3-2 \n 4-2 \n 1-3 \n 2-3 \n 3-3 \n 4-3" | ./from_file.py --columns 4 | rofi -dmenu -columns 4 -lines 3

"""

# MIT No Attribution
#
# Copyright (c) 2020 Daguhh
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software IS
# furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


"""
A simple python script to pipe elements to display line by line in rofi
"""

__author__ = "Daguhh"
__license__ = "MIT-0"


import argparse
import sys
from itertools import chain


def main():
    """ pipe row by row list into column by column lisr readable by rofi """

    args = get_arguments()
    rofi_datas = sys.stdin.read()
    rofi_datas = rofi_datas if len(rofi_datas) > 0 else rofi_datas[0]
    rofi_txt = rofi_transpose(rofi_datas, int(args.columns), args.sep)
    print(rofi_txt)


def rofi_transpose(rofi_datas, column_number, sep):
    """
    Transpose (math) a row by row rofi-list into column by column rofi-list
    given column number

    Parameters
    ----------
    lst : str
        row by row elements
    col_nb : int
        number of column to display
    sep : str
        separator character

    Returns
    -------
    str
        A rofi-list, column by column elements

    Examples
    --------

    >>> by_row = "1\n2\n3\n4\n5\n6"
    >>> rofi_transpose(by_row, 3)
    "1\n4\n2\n5\n3\n6"

    """

    byrow_datas = rofi2list(rofi_datas, '{}'.format(sep))
    bycol_datas = list_transpose(byrow_datas, column_number)

    return list2rofi(bycol_datas, sep)


def list2rofi(datas, sep):
    """
    Convert python list into a list formatted for rofi

    Parameters
    ----------
    datas : list
        elements stored in a list
    sep : str
        separator character

    Returns
    -------
    str
        elements separated by line-breaks

    Examples
    --------

    >>> my_list = [1,2,3,4,5,6]
    >>> list2rofi(my_list]
    "1\n2\n3\n4\n5\n6"
    """

    return '\n'.join(datas)


def rofi2list(datas, sep):
    """
    Convert list formatted for rofi into python list object

    Parameters
    ----------
    datas : str
        a string with element separeted by line-breaks
    sep : str
        separator character

    Returns
    -------
    list
        elements of datas in a list

    Examples
    --------

    >>> rofi_list = "1\n2\n3\n4\n5\n6"
    >>> rofi2list(rofi_list)
    [1,2,3,4,5,6]
    """

    return datas.split(sep)


def list_transpose(lst, col_nb):
    """
    Transpose (math) a row by row list into column by column list
    given column number

    Parameters
    ----------
    lst : list
        row by row elements
    col_nb : int
        number of column to display

    Returns
    -------
    list
        A list that represent column by column elements

    Examples
    --------

    >>> my_list = [1,2,3,4,5,6]
    >>> weekly_transpose(my_list, col_nb=3)
    [1,4,2,5,3,6]
    """

    # split into row
    iter_col = range(len(lst) // col_nb)
    row_list = [lst[i * col_nb : (i + 1) * col_nb] for i in iter_col]

    # transpose : take 1st element for each row, then 2nd...
    iter_row = range(len(row_list[0]))
    col_list = [[row[i] for row in row_list] for i in iter_row]

    # chain columns
    lst = list(chain(*col_list))

    return lst


def get_arguments():
    """Parse command line arguments"""

    parser = argparse.ArgumentParser(
        description="""pipe to rofi a row by row content"""
    )

    parser.add_argument(
        "-c", "--columns", help="""columns number""", dest="columns", default=1
    )
    parser.add_argument(
        "-s",
        "--sep",
        help="""separator, defaut='\n'""",
        dest="sep",
        default='\n',
    )
    args = parser.parse_args()
    return args


if __name__ == '__main__':

    main()
