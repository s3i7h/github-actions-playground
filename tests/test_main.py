from unittest import TestCase

from src.main import add


class MainTestCase(TestCase):
    def test_add(self):
        self.assertEqual(5, add(2, 3))
