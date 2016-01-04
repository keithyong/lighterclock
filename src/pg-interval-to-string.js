export default function(age) {
    var bannerAge = '';

    if (age.seconds === undefined) {
        age.seconds = 0;
    }

    var n = Object.keys(age).slice(0, 2);

    n.map(time => {
        bannerAge += age[time] + ' ' + time + ' ';
    });

    bannerAge = bannerAge.slice(0, -1);
    return bannerAge;
}
