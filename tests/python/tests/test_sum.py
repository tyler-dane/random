import unittest
from fractions import Fraction

def sum(arg):
    total = 0
    for val in arg:
        total += val
    return total

class TestSum(unittest.TestCase):
    def test_list_int(self):
        """
        Test using a list of integers
        """
        data = [1,2,3]
        result = sum(data)
        self.assertEqual(result,6)

    def test_list_fraction(self):
        """
        Test using a list of fractions
        * This should fail*
        """
        data = [Fraction(1,4), Fraction(1,4), Fraction(2,5)]
        result = sum(data)
        self.assertEqual(result, -22)

if __name__ == '__main__':
    unittest.main()