{{- range . }}
<html>
<head>
    <title>Trivy Security Report</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        h1, h2 {
            font-family: Arial, sans-serif;
        }
        .accordion {
            cursor: pointer;
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #f2f2f2;
            margin: 5px 0;
            border-radius: 5px;
            text-align: left;
        }
        .panel {
            display: none;
            padding: 10px;
            border: 1px solid #ccc;
            border-top: none;
            margin-bottom: 5px;
        }
        #filter {
            margin: 10px 0;
        }
        .dropdown {
            margin: 10px 0;
            position: relative;
            display: inline-block;
        }
        .dropdown select {
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            background-color: #f9f9f9;
            font-size: 16px;
            cursor: pointer;
            transition: border-color 0.3s;
        }
        .dropdown select:hover {
            border-color: #888;
        }
    </style>
    <script>
        function togglePanel(id) {
            var panel = document.getElementById(id);
            if (panel.style.display === "block") {
                panel.style.display = "none";
            } else {
                panel.style.display = "block";
            }
        }

        function filterBySeverity() {
            var selectedSeverity = document.getElementById("filter").value;
            var rows = document.querySelectorAll("tbody tr[data-severity]");
            rows.forEach(function(row) {
                if (selectedSeverity === "all" || row.getAttribute("data-severity") === selectedSeverity) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        }
    </script>
</head>
<body>
    <h1>Trivy Security Report</h1>
    <h2>Target: {{ .Target }}</h2>

    <div class="dropdown">
        <label for="filter">Filter by Severity:</label>
        <select id="filter" onchange="filterBySeverity()">
            <option value="all">All</option>
            <option value="LOW">Low</option>
            <option value="MEDIUM">Medium</option>
            <option value="HIGH">High</option>
            <option value="CRITICAL">Critical</option>
        </select>
    </div>

    <table>
        <thead>
            <tr>
                <th>Vulnerability ID</th>
                <th>Package ID</th>
                <th>Package Name</th>
                <th>Installed Version</th>
                <th>Fixed Version</th>
                <th>Status</th>
                <th>Severity</th>
                <th>Description</th>
                <th>References</th>
                <th>Published Date</th>
                <th>Last Modified Date</th>
            </tr>
        </thead>
        <tbody>
        {{- range .Vulnerabilities }}
            <tr data-severity="{{ .Severity }}">
                <td>{{ .VulnerabilityID }}</td>
                <td>{{ .PkgID }}</td>
                <td>{{ .PkgName }}</td>
                <td>{{ .InstalledVersion }}</td>
                <td>{{ .FixedVersion }}</td>
                <td>{{ .Status }}</td>
                <td>{{ .Severity }}</td>
                <td>{{ .Description }}</td>
                <td>
                    <div class="accordion" onclick="togglePanel('panel-{{ .VulnerabilityID }}')">
                        References ({{ len .References }})
                    </div>
                    <div class="panel" id="panel-{{ .VulnerabilityID }}">
                        <ul>
                        {{- range .References }}
                            <li><a href="{{ . }}" target="_blank">{{ . }}</a></li>
                        {{- end }}
                        </ul>
                    </div>
                </td>
                <td>{{ .PublishedDate }}</td>
                <td>{{ .LastModifiedDate }}</td>
            </tr>
        {{- end }}
        </tbody>
    </table>
</body>
</html>
{{- end }}
