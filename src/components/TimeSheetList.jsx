import React from 'react'
import TimeSheetListItem from './TimeSheetListItem.jsx'

export default class TimeSheetList extends React.Component {
    render() {
        let timesheets = this.props.timesheet

        let timesheetsDOM = this.props.timesheets.map((timesheet) => {
            return (
                <TimeSheetListItem title={timesheet.title} total_time={timesheet.total_time} />
            )
        })

        return (
            <ul>
                {timesheetsDOM}
            </ul>
        )
    }
}
