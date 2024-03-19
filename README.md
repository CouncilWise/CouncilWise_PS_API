# CouncilWise PowerShell API Functions
A list of PowerShell functions to drive the CouncilWise API, will hopefully make using the API far simpler for users who are unfamiliar with using API endpoints.
While not every environment has been tested, they should run on any version of PowerShell that is installed on any operating system it supports, as well as within Azure Automation accounts.
The commands should simply return arrary's of data that can be used however you wish.

We have also provided a few basic SQL conversion functions that may help those who want to then put the API data into their own database.
These were not created by us and instead were created by ChatGPT, so YMMV with their use.

**Please Note:**
 - These are provided as a working template for others to use or manipulate if they so wish to do so
 - Not every API call has its own function, but you should get the idea of how these are created meaning that you can expand and create more if you so wish
	 - If you do create more, we ask that you please provide it to support@councilwise.com.au so that we can upload it here for others to use
 - There is ways of making these functions far more efficient, for example wrapping the paginated ones in `ForEach-Object -Parallel` commands. These have been intentionally left out as those kinds of commands are only available on more modern PowerShell versions
