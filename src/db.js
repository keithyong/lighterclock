import pg from 'pg'
import query from './query'

export function grabTimeSheetList(username, callback) {
    query('SELECT * FROM time_sheet WHERE username=\'' + username + '\'', (rows) => {
        callback(rows)
    })
}

export function grabTimeSheetInfo(id, callback) {
    query('SELECT * FROM time_sheet JOIN punch ON time_sheet.id=punch.time_sheet_id WHERE time_sheet_id=\'' + id + '\'', (rows) => {
        callback(rows)
    })
}
