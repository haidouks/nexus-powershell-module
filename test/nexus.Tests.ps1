$ModuleManifestName = 'nexus.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\$ModuleManifestName"

#region variables
$nexusUser = "admin"
$nexusPass = ConvertTo-SecureString "admin123" -AsPlainText -Force 
$nexusCred = New-Object System.Management.Automation.PSCredential ($nexusUser, $nexusPass)
$nexusBaseURI = "http://localhost:8081/service/rest/"
#endregion

Describe 'Module Manifest Tests' {
    It 'Passes Test-ModuleManifest' {
        Test-ModuleManifest -Path $ModuleManifestPath | Should Not BeNullOrEmpty
        $? | Should Be $true 
    }
    It "If module configuration is right" {
        {Import-Module $ModuleManifestPath -Force} | Should -Not -Throw
    }   
}

Set-NexusCredential -nexusBaseURI $nexusBaseURI -nexusCredential $nexusCred

Describe "Get Nexus Repositories" {
    Context "If credential and nexus api url is valid" {
        Mock Get-NexusRepositories {
            $json = @"
[{"name":"spring-proxy","format":"maven2","type":"proxy","url":"http://nexus3.tool.zfu.zb:8081/repository/spring-proxy"},{"name":"maven-proxy","format":"maven2","type":"proxy","url":"http://nexus3.tool.zfu.zb:8081/repository/maven-proxy"},{"name":"fed-group","format":"npm","type":"group","url":"http://nexus3.tool.zfu.zb:8081/repository/fed-group"}]
"@            
        return $json | convertfrom-json
        }
        It "It should return all repositories" {
            {Get-NexusRepositories} | Should -Not -Throw
            (Get-NexusRepositories).type.Count | Should -BeGreaterThan 1
        }
    }
}



