getHealth()
async function getHealth () {
  try {
    await fetch('/health')
        .then(response => {
          console.log(response.status)
        })
        .catch(err => {
            console.log(err)
        })
  } catch (err) {
      console.log(err)
  }
}