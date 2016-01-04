import {insertUser, deleteUser, insertTimeSheet, grabTimeSheetList, grabTimeSheetInfo} from '../src/db';

import {expect} from 'chai';

describe('users', () => {

    describe('deleteUser', () => {
        it('deletes a user from the database', () => {
            var hi = {};

            deleteUser('db_spec', (rows, error) => {
                console.log(hi)
                hi = rows;
            });

            expect(hi).to.equal(null);
        });
    });

    describe('insertUser', () => {
        it('inserts a new user into the database', () => {
            insertUser('db_spec', 'test_password', (rows, error) => {
                console.log(rows)
            });
        });
    });

});

describe('timesheets', () => {

    describe('grabTimeSheetList', () => {
        it('grabs the right time sheets', () => {
            grabTimeSheetList('db_spec', (rows) => {
                console.log(rows);
                expect(rows).to.equal({});
            });
        });
    });

    describe('grabTimeSheetInfo', () => {
        it('grabs the right time sheets', () => {
            grabTimeSheetList('keithy', (rows) => {
                console.log(rows);
                expect(rows).to.equal({});
            });
        });
    });

});
