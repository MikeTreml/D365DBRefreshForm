
Stop-D365Environment -All -Kill -Verbose
Remove-D365Database -DatabaseName 'AxDB_Original' -Verbose
Start-D365Environment -All
