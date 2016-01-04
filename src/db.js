import pg from 'pg'
import query from './query'

function formatBinding(str) {
    return '\'' + str + '\'';
};
export function grabTimeSheetList(username, callback) {
    query('SELECT * FROM time_sheet WHERE username=' + formatBinding(username) + '', (rows) => {
        callback(rows)
    })
}

export function grabTimeSheetInfo(id, callback) {
    query('SELECT * FROM time_sheet JOIN punch ON time_sheet.id=punch.time_sheet_id WHERE time_sheet_id=' + formatBinding(id), (rows) => {
        callback(rows)
    })
}

export function punch(timesheet_id, type, callback) {
    var typeBinding;
    switch(type) {
        case 'in':
            typeBinding = formatBinding('in');
            break;
        case 'out':
            typeBinding = formatBinding('out');
            break;
        default:
            return;
    }

    query('INSERT INTO punch VALUES (default, ' + formatBinding(timesheet_id) + ', now(), ' + typeBinding + ')', (rows) => {
        callback(rows);
    });
}
