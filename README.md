# 🧬 RNA-seq Shiny Visualization App

## Overview
This interactive **R Shiny web application** allows users to visualize **gene expression profiles** derived from RNA-seq data processed using a Nextflow RNA-seq pipeline.  

It provides an intuitive interface to explore gene-level counts across different brain regions and clinical groups.  
Users can visualize **distribution plots** of gene expression and **group comparisons** (e.g., ALS vs Control) interactively.

---

## 🔍 Features
- Switch between **regions** (e.g., medial or lateral)
- Select **any gene** interactively
- Compare **gene expression across diagnostic groups**
- Generates:
  - **Distribution plot** (histogram + density)
  - **Bar plot** (group-wise mean ± SD)
- Uses **Bowser lab metadata** format

---

## 🧠 Context in Workflow
This tool is designed for **post-processing** and visualization after running a **Nextflow RNA-seq pipeline**.  
It expects as input the processed count data (e.g., from *tximport* or *DESeq2*) and a corresponding metadata file.

Typical workflow:
1. RNA-seq reads aligned and quantified (via Nextflow pipeline)
2. Gene-level counts exported as CSV files (e.g., `txi_medial_result_net.csv`)
3. Metadata file prepared with sample and clinical information
4. Load files into this Shiny app for interactive exploration

---

## 📁 Repository Structure

rna_seq_shiny_app/
├── app.R # Main Shiny app
├── data/
│ ├── metadata_labdefined_net.csv
│ ├── txi_medial_result_net.csv
│ └── txi_lateral_result_net.csv
├── requirements.txt # R packages required
└── README.md # Documentation


---

## ⚙️ Installation

### 1. Prerequisites
- R (version ≥ 4.2)
- RStudio (recommended)

### 2. Install Required Packages
Open R or RStudio and run:
```r
install.packages(c("shiny", "readr", "dplyr", "tidyverse", "ggplot2"))
```

### 3. Clone this repository 
```bash
git clone https://github.com/<your-username>/rna_seq_shiny_app.git
cd rna_seq_shiny_app
```

### 4. Add your data

Place your processed files into the /data directory:

-metadata_labdefined_net.csv

-txi_medial_result_net.csv

-txi_lateral_result_net.csv

### 5. Run the app

```r
shiny::runApp("app.R")
```

## 🧬 Input Data Format

### Metadata (`metadata_labdefined_net.csv`)

**Expected columns:**

| Column | Description |
|--------|--------------|
| ExternalSampleId | Unique sample ID |
| Sex | Sample sex |
| Site of Motor Onset | Clinical metadata |
| Age at Death | Numeric |
| Sample Source | Source tissue |
| Final Subject Group - Bowser lab defined | Diagnostic group (e.g., ALS, Control) |

---

### Expression Files (`txi_medial_result_net.csv`, `txi_lateral_result_net.csv`)

- **First column:** `gene`  
- **Subsequent columns:** normalized counts per sample (`ExternalSampleId`)

**Example:**

| gene | Sample_01 | Sample_02 | Sample_03 |
|------|------------|------------|------------|
| SOD1 | 120 | 130 | 98 |
| FUS  | 400 | 380 | 450 |

---

## 📊 Usage Instructions

1. Choose a **region** (medial or lateral)  
2. Select a **gene** from the dropdown  
3. Pick one or more **subject groups** (e.g., ALS, Control)  
4. View the following plots:
   - **Distribution Plot:** Histogram + density of expression  
   - **Group Comparison Plot:** Mean ± SD across groups  

---

## 📈 Output Examples

### 🧪 Distribution Plot
Displays the distribution of expression levels for a selected gene across all samples in the chosen region.

### 🧫 Group Comparison Bar Plot
Compares mean expression (±SD) for selected groups, helping visualize differential expression trends.

---

## 🛠 Troubleshooting

- Ensure all input CSVs are in the `/data` folder.  
- Column names must exactly match those expected in the code (e.g., `gene`, `ExternalSampleId`).  
- If plots do not render:
  - Check for missing `selected_gene` or `selected_group` inputs.  
  - Verify that your CSV uses commas as separators.  

---

## 📦 requirements.txt

**For reference:**

shiny
readr
dplyr
tidyverse
ggplot2

## 🧩 Future Improvements

- Add differential expression testing (DESeq2 integration)  
- Support for TPM/FPKM normalization  
- Enhanced color customization per group  
- Export plots as PNG/PDF  


