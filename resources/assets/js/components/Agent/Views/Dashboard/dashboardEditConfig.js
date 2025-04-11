export const donutChartData = {
    labels: ['Low', 'Medium', 'Normal', 'Warning',],
    datasets: [
        {
            backgroundColor: ['#41B883', '#E46651', '#00D8FF', '#DD1B16'],
            data: [40, 20, 80, 10]
        }
    ]
}

export const donutChartOptions = {
    responsive: true, maintainAspectRatio: false, plugins:{legend: false}
}

export const barChartData = {
    labels: [ 'Low', 'Medium', 'Normal', 'Warning', 'High', 'Emergency'],
        datasets: [{
        label: 'Dataset',
        data: [10, 20, 30, 40, 50, 60],
        backgroundColor: [
            'rgba(255, 99, 132, 0.2)',
            'rgba(255, 159, 64, 0.2)',
            'rgba(255, 205, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(153, 102, 255, 0.2)',
        ]
    }]
}
export const barChartOptions =  {
    responsive: true, plugins:{legend: false}
}

export const immediateTickets = [
    {label: 'immediate_ticket_1', link: 'javascript:;', overdue: true, dueTime: 'immediate_ticket_1_time'},
    {label: 'immediate_ticket_2', link: 'javascript:;', overdue: false, dueTime: 'immediate_ticket_2_time'},
    {label: 'immediate_ticket_3', link: 'javascript:;', overdue: false, dueTime: 'immediate_ticket_3_time'},
    {label: 'immediate_ticket_4', link: 'javascript:;', overdue: false, dueTime: 'immediate_ticket_4_time'},
]

export const recentActivities = [
    { imageUrl: "", agentType: 'agent', message: 'recent_activity_msg_1', date: '2022-10-19' },
    { imageUrl: "", agentType: 'admin', message: 'recent_activity_msg_2', date: '2022-01-02' },
    { imageUrl: "", agentType: 'admin', message: 'recent_activity_msg_3', date: '2023-12-14' },
    { imageUrl: "", agentType: 'agent', message: 'recent_activity_msg_4', date: '2024-01-24' },
]

export const agentSummary = [
    { imageUrl: "", name: 'agent', reopenedTickets: 12, overdueTickets: 34 },
    { imageUrl: "", name: 'admin', reopenedTickets: 25, overdueTickets: 46 }
]

export const departmentSummaries = [
    { name: 'support', summaryMessage: 'dept_summary_msg_1', badgeValue: 34 },
    { name: 'development', summaryMessage: 'dept_summary_msg_2', badgeValue: 6 }
]

export const agentPerformances = [
    { message: 'agent_performance_msg_1', percent: 50 },
    { message: 'agent_performance_msg_2', percent: 10 },
    { message: 'agent_performance_msg_3', percent: 60 },
    { message: 'agent_performance_msg_4', percent: 5 },
]

export const systemAnalysisSummaries = [
    { message: 'summary_msg_1', value: 6000 },
    { message: 'summary_msg_2', value: 34 },
    { message: 'summary_msg_3', value: 567 },
    { message: 'summary_msg_4', value: 9 },
    { message: 'summary_msg_5', value: 107 },
]

