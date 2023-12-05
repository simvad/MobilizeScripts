# Mobilize Scripts
This repo contains scripts, mainly PowerShell, for the daily IT administration at Mobilize Strategy Consulting A/S. The relevant stack includes:

- Microsoft Office
- Pleo
- TimeLog

## Future development

So far, the scripts only deal with on and offboarding, but the ambition is to also include:
- Group/Team creation
- Status logs

## Branches

### Main
Main is actively maintained and used in daily work. It takes arguments in CSV format or by piping, and does not deal with anything except default roles in 

### Default-args-w-roles
This branch was main at the start of the project but is now unmaintained. It takes parameter as a standard PS script (as opposed to csv or piping) and tries to deal with roles in Microsoft role
