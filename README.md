# secret_santa

## Configure email settings

Create an .env file in the secret-santa directory, like so:

```
export FROM_EMAIL='glitter@wit.ch'
export FROM_NAME='Santa'
export EMAIL_SUBJECT='Your Secret Santa Assignment!'
export GMAIL_USER='glitter@wit.ch'
export GMAIL_PASS='your-password-see-note'
```
*Important:* If you have two-factor authentication enabled for your Gmail account, you will need to generate an app-specific password to run this script.

## CSV file

Create a 'people' CSV file with the following fields (no header):

```
  ID,NAME,ADDRESS,EMAIL ADDRESS,DETAILS,EXCLUSIONS
```

The "DETAILS" field will generally contain a mailing address but can include other instructions. Line breaks are supported.
The "EXCLUSIONS" field should be a semicolon-separated list of ids (from the first column) signifying people that the person should not be assigned to give a gift to (for instance, if they are not willing to ship internationally, or whatever).

## Email Template

Create a 'template' text file. Use the following %%DOUBLE_PERCENT_DELIMITED%% variable names in the template to substitute the specifics for a given email to a particular person:

* `%%NAME%%`: used to address the person receiving the email
* `%%GIVING_TO%%`: used to give the name of the person they're giving a gift to
* `%%ADDRESS%%`: giftee's mailing address
* `%%DETAILS%%`: the DETAILS field from the CSV (most likely gift hints)

## Running the script
You can test the assignments via `bundle exec rake test_assign['people.csv']`

Once you're confident that you have your people file configured correctly with all exclusions, you can send the emails with `bundle exec rake email_assign['people.csv','email.txt']`.
