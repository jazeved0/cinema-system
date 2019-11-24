from sqlalchemy import BigInteger, Boolean, CHAR, CheckConstraint, Column, Date, ForeignKey, ForeignKeyConstraint, Integer, String, Table, Text, UniqueConstraint
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

"""
Contains sqlalchemy ORM models for the Team20 database schema
"""


Base = declarative_base()
metadata = Base.metadata


class User(Base):
    __tablename__ = 'User'
    __table_args__ = (
        CheckConstraint(
            "status = ANY (ARRAY['All'::bpchar, 'Pending'::bpchar, 'Declined'::bpchar, 'Approved'::bpchar])"),
    )

    username = Column(String(240), primary_key=True)
    status = Column(CHAR(8), nullable=False, default="Pending")
    password = Column(CHAR(44), nullable=False)
    firstname = Column(String(240), nullable=False)
    lastname = Column(String(240), nullable=False)


class Customer(User):
    __tablename__ = 'customer'

    username = Column(ForeignKey(
        'User.username', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)


class Employee(User):
    __tablename__ = 'employee'

    username = Column(ForeignKey(
        'User.username', ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)


class Admin(Employee):
    __tablename__ = 'admin'

    username = Column(ForeignKey('employee.username',
                                 ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)


class Manager(Employee):
    __tablename__ = 'manager'
    __table_args__ = (
        UniqueConstraint('state', 'city', 'zipcode', 'street'),
    )

    username = Column(ForeignKey('employee.username',
                                 ondelete='CASCADE', onupdate='CASCADE'), primary_key=True)
    state = Column(CHAR(2), nullable=False)
    city = Column(String(240), nullable=False)
    zipcode = Column(CHAR(5), nullable=False)
    street = Column(String(240), nullable=False)
    companyname = Column(ForeignKey(
        'company.name', ondelete='SET NULL', onupdate='CASCADE'))

    company = relationship('Company')


class Company(Base):
    __tablename__ = 'company'

    name = Column(String(240), primary_key=True)


TCompanyDerived = Table(
    'companyderived', metadata,
    Column('name', String(240)),
    Column('numcitycover', BigInteger),
    Column('numtheater', BigInteger),
    Column('numemployee', BigInteger)
)


class Movie(Base):
    __tablename__ = 'movie'

    name = Column(String(240), primary_key=True, nullable=False)
    releasedate = Column(Date, primary_key=True, nullable=False)
    duration = Column(Integer, nullable=False)


TUserDerived = Table(
    'userderived', metadata,
    Column('username', String(240)),
    Column('status', CHAR(8)),
    Column('password', CHAR(44)),
    Column('firstname', String(240)),
    Column('lastname', String(240)),
    Column('creditcardcount', BigInteger),
    Column('isadmin', Boolean),
    Column('ismanager', Boolean),
    Column('iscustomer', Boolean),
    Column('usertype', Text)
)


class Creditcard(Base):
    __tablename__ = 'creditcard'

    creditcardnum = Column(CHAR(16), primary_key=True)
    owner = Column(ForeignKey('customer.username',
                              ondelete='CASCADE', onupdate='CASCADE'), nullable=False)

    customer = relationship('Customer')
    movieplay = relationship('Movieplay', secondary='used')


class Theater(Base):
    __tablename__ = 'theater'

    theatername = Column(String(240), primary_key=True, nullable=False)
    companyname = Column(ForeignKey('company.name', ondelete='CASCADE',
                                    onupdate='CASCADE'), primary_key=True, nullable=False)
    state = Column(CHAR(2), nullable=False)
    city = Column(String(240), nullable=False)
    zipcode = Column(CHAR(5), nullable=False)
    capacity = Column(Integer, nullable=False)
    manager = Column(ForeignKey('manager.username',
                                ondelete='SET NULL', onupdate='CASCADE'))
    street = Column(String(240), nullable=False)

    company = relationship('Company')
    manager1 = relationship('Manager')


class Movieplay(Base):
    __tablename__ = 'movieplay'
    __table_args__ = (
        ForeignKeyConstraint(['moviename', 'releasedate'], [
                             'movie.name', 'movie.releasedate'], ondelete='CASCADE', onupdate='CASCADE'),
        ForeignKeyConstraint(['theatername', 'companyname'], [
                             'theater.theatername', 'theater.companyname'], ondelete='CASCADE', onupdate='CASCADE')
    )

    date = Column(Date, primary_key=True, nullable=False)
    moviename = Column(String(240), primary_key=True, nullable=False)
    releasedate = Column(Date, primary_key=True, nullable=False)
    theatername = Column(String(240), primary_key=True, nullable=False)
    companyname = Column(String(240), primary_key=True, nullable=False)

    movie = relationship('Movie')
    theater = relationship('Theater')


class Visit(Base):
    __tablename__ = 'visit'
    __table_args__ = (
        ForeignKeyConstraint(['theatername', 'companyname'], [
                             'theater.theatername', 'theater.companyname'], ondelete='CASCADE', onupdate='CASCADE'),
    )

    id = Column(Integer, primary_key=True)
    date = Column(Date, nullable=False)
    username = Column(ForeignKey(
        'User.username', ondelete='CASCADE', onupdate='CASCADE'), nullable=False)
    theatername = Column(String(240), nullable=False)
    companyname = Column(String(240), nullable=False)

    theater = relationship('Theater')
    User = relationship('User')


TUsed = Table(
    'used', metadata,
    Column('creditcardnum', ForeignKey('creditcard.creditcardnum',
                                       ondelete='CASCADE', onupdate='CASCADE'), primary_key=True, nullable=False),
    Column('playdate', Date, primary_key=True, nullable=False),
    Column('moviename', String(240), primary_key=True, nullable=False),
    Column('releasedate', Date, primary_key=True, nullable=False),
    Column('theatername', String(240), primary_key=True, nullable=False),
    Column('companyname', String(240), primary_key=True, nullable=False),
    ForeignKeyConstraint(['playdate', 'moviename', 'releasedate', 'theatername', 'companyname'], ['movieplay.date', 'movieplay.moviename',
                                                                                                  'movieplay.releasedate', 'movieplay.theatername', 'movieplay.companyname'], ondelete='CASCADE', onupdate='CASCADE')
)
