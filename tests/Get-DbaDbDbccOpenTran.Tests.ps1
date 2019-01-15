$CommandName = $MyInvocation.MyCommand.Name.Replace(".Tests.ps1", "")
Write-Host -Object "Running $PSCommandPath" -ForegroundColor Cyan
. "$PSScriptRoot\constants.ps1"

Describe "$CommandName Unit Tests" -Tag 'UnitTests' {
    Context "Validate parameters" {
        [object[]]$params = (Get-Command -Name $CommandName).Parameters.Keys
        $knownParameters = 'SqlInstance', 'SqlCredential', 'Database', 'EnableException'

        It "Should contain our specific parameters" {
            ( (Compare-Object -ReferenceObject $knownParameters -DifferenceObject $params -IncludeEqual | Where-Object SideIndicator -eq "==").Count ) | Should Be $knownParameters.Count
        }
    }
}
Describe "$commandname  Integration Test" -Tag "IntegrationTests" {
    Context "Gets results for Open Transactions" {
        $props = 'ComputerName', 'InstanceName', 'SqlInstance', 'Database', 'Cmd', 'Output', 'Field', 'Data'
        $result = Get-DbaDbDbccOpenTran -SqlInstance $script:instance1

        It "returns results for DBCC OPENTRAN" {
            $result | Should Not Be $null
        }

        It "returns multiple results" {
            $result.Count -gt 0 | Should Be $true
        }

        foreach ($prop in $props) {
            $p = $result[0].PSObject.Properties[$prop]
            It "Should return property: $prop" {
                $p.Name | Should Be $prop
            }
        }

        $result = Get-DbaDbDbccOpenTran -SqlInstance $script:instance1 -Database tempDB

        It "returns results for a database" {
            $result | Should Not Be $null
        }
    }
}
