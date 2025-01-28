let data = {};

if(process.env.BRANCH === "git-commit") {
	data.date = "git Last Modified";
}

module.exports = data;