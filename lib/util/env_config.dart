enum Profile { prod, dev }

const Profile activeProfile = Profile.prod;

///don't change it
const gatewayUrl = activeProfile == Profile.dev
    ? 'https://ayaibnebo9.execute-api.eu-west-1.amazonaws.com/staging'
    : 'https://api.gotake-it.com';
