"""
Testing all of the following:
    * Property decorator
    * Inheritance
    * Mix-ins
    * Protocols
"""

import abc

class Person(object):
    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, new_name):
        if not new_name:
            raise "No name to set!"
        self._name = new_name

class AbstractTalker(object):
    __metaclass__ = abc.ABCMeta

    @abc.abstractmethod
    def format(self, message):
        pass

    def say(self, msg):
        print(self.format(msg))

class LoudTalker(object):
    def format(self, message):
        return "%s: %s!!" % (self.name, message)

class UnsureTalker(object):
    def format(self, message):
        return "(%s) %s..." % (self.name, message)

class John(Person, LoudTalker, AbstractTalker):
    def __init__(self):
        self.name = "John"

class Jake(Person, LoudTalker, AbstractTalker):
    def __init__(self):
        self.name = "Jake"

class Josh(Person, UnsureTalker, AbstractTalker):
    def __init__(self):
        self.name = "Josh"

class PersonIterator(object):
    def __init__(self, people, limit):
        self.people = people
        self.index = 0
        self.limit = limit

    def __iter__(self):
        return self

    def __next__(self):
        if self.index >= self.limit:
            raise StopIteration
        person = self.people.people[self.index]
        message = self.people.messages[self.index]
        self.index += 1
        return (person, message)


class PeopleSet(object):
    def __init__(self):
        self.people = [John(), Jake(), Josh()]
        self.messages = [
            "Hello, great to meet you",
            "Great to meet you too",
            "Uh, great to meet you"
        ]

    def __iter__(self):
        return PersonIterator(self, 3)

for person, msg in PeopleSet():
    person.say(msg)


