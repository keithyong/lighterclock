import pg from 'pg'
import query from './query'

export function grabTimeSheetList(username, callback) {
    query('SELECT * FROM time_sheet WHERE username=\'' + username + '\'', (rows) => {
        callback(rows)
    })
}
