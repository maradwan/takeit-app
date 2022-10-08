enum Profile { prod, dev }

const Profile activeProfile = Profile.dev;

///don't change it
final gatewayUrl = activeProfile == Profile.dev
    ? 'https://ayaibnebo9.execute-api.eu-west-1.amazonaws.com/staging'
    : 'https://api.gotake-it.com';
