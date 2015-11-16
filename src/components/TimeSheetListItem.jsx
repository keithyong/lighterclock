import React from 'react'
import pgstr from '../pg-interval-to-string'

export default class TimesheetListItem extends React.Component {
    render() {
        return (
            <li>
                <b>{this.props.title}</b>
                <p>{pgstr(this.props.total_time)}</p>
            </li>
        )
    }
}
