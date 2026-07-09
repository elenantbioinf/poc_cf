#!/usr/bin/env python3

##############################
# Plot target regions and low-coverage gaps
##############################

# Input:
# 1. Target BED file
# 2. Low-coverage gaps TSV file
# 3. Output PNG plot

# Output:
# 1. PNG plot of target regions and low-coverage gaps

# Libraries
import sys

import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.patches import Rectangle
from matplotlib import font_manager

# Variables
BED_TARGET = sys.argv[1]
GAPS_TSV = sys.argv[2]
OUT_PLOT = sys.argv[3]


# Function to read BED file
def read_bed_file(bed_file):
    bed_df = pd.read_csv(
        bed_file,
        sep="\t",
        comment="#",
        header=None,
        names=["chrom", "start", "end", "region"]
    )

    bed_df["start"] = bed_df["start"].astype(int)
    bed_df["end"] = bed_df["end"].astype(int)

    bed_df = bed_df.sort_values(
        ["chrom", "start", "end"]
    ).reset_index(drop=True)

    return bed_df


# Function to read gaps TSV file
def read_gaps_file(gaps_file):
    gaps_df = pd.read_csv(
        gaps_file,
        sep="\t"
    )

    gaps_df["start"] = gaps_df["start"].astype(int)
    gaps_df["end"] = gaps_df["end"].astype(int)

    return gaps_df


# Function to find gaps overlapping each target region
def get_target_gap_segments(bed_df, gaps_df):

    target_gap_segments = {}

    for region_index, region in bed_df.iterrows():

        target_gap_segments[region_index] = []

        overlapping_gaps = gaps_df[
            (gaps_df["chrom"] == region["chrom"]) &
            (gaps_df["end"] > region["start"]) &
            (gaps_df["start"] < region["end"])
        ]

        for _, gap in overlapping_gaps.iterrows():

            gap_start = max(gap["start"], region["start"])
            gap_end = min(gap["end"], region["end"])

            if gap_start < gap_end:
                target_gap_segments[region_index].append((gap_start, gap_end))

    return target_gap_segments


# Function to format target labels
def format_target_label(region_name, index):

    region_name = str(region_name)

    if region_name.startswith("CFTR_exon"):
        return region_name.replace("CFTR_exon", "E")

    return f"R{index + 1}"


# Function to plot target regions and low-coverage gaps
def plot_target_regions(bed_df, gaps_df, out_plot):

    # General figure style
    available_fonts = {font.name for font in font_manager.fontManager.ttflist}

    if "Montserrat" in available_fonts:
        plot_font = "Montserrat"
    else:
        plot_font = "DejaVu Sans"

    plt.rcParams.update({
        "font.family": plot_font,
        "font.size": 9,
        "axes.titlesize": 13
    })

    # Colors
    coverage_color = "#c8e6c9"
    low_coverage_color = "#b2182b"
    border_color = "#4d4d4d"
    text_color = "#222222"

    # Plot dimensions
    region_width = 1
    region_height = 0.28
    region_spacing = 0.18

    fig_width = max(11, len(bed_df) * 0.42)
    fig_height = 2.6

    fig, ax = plt.subplots(figsize=(fig_width, fig_height))
    fig.patch.set_facecolor("white")
    ax.set_facecolor("white")

    target_gap_segments = get_target_gap_segments(bed_df, gaps_df)

    for index, region in bed_df.iterrows():

        x = index * (region_width + region_spacing)
        y = 0

        # Draw target region
        region_patch = Rectangle(
            (x, y),
            region_width,
            region_height,
            facecolor=coverage_color,
            edgecolor=border_color,
            linewidth=0.45
        )

        ax.add_patch(region_patch)

        # Draw low-coverage gaps inside the target region
        region_start = region["start"]
        region_end = region["end"]
        region_length = region_end - region_start

        for gap_start, gap_end in target_gap_segments[index]:

            relative_start = (gap_start - region_start) / region_length
            relative_end = (gap_end - region_start) / region_length

            gap_x = x + relative_start * region_width
            gap_width = (relative_end - relative_start) * region_width

            # Make very small gaps visible
            gap_width = max(gap_width, 0.025)

            gap_patch = Rectangle(
                (gap_x, y),
                gap_width,
                region_height,
                facecolor=low_coverage_color,
                edgecolor=low_coverage_color,
                linewidth=0
            )

            ax.add_patch(gap_patch)

        # Target label
        ax.text(
            x + region_width / 2,
            y - 0.08,
            format_target_label(region["region"], index),
            ha="center",
            va="top",
            fontsize=8.5,
            color=text_color
        )

    total_width = len(bed_df) * (region_width + region_spacing)

    ax.set_xlim(-0.35, total_width)
    ax.set_ylim(-0.25, 0.65)

    ax.set_xticks([])
    ax.set_yticks([])
    ax.set_frame_on(False)

    ax.set_title(
        "Target region coverage evaluability map",
        fontsize=13,
        fontweight="bold",
        color=text_color,
        pad=4,
        y=0.90
    )

    # Legend
    legend_coverage = Rectangle(
        (0, 0),
        1,
        1,
        facecolor=coverage_color,
        edgecolor=border_color,
        linewidth=0.45,
        label="Coverage >=20X"
    )

    legend_low_coverage = Rectangle(
        (0, 0),
        1,
        1,
        facecolor=low_coverage_color,
        edgecolor=low_coverage_color,
        label="Coverage <20X"
    )

    # Leave space for legend and caption
    fig.subplots_adjust(
        left=0.03,
        right=0.97,
        top=0.78,
        bottom=0.34
    )

    fig.legend(
        handles=[legend_coverage, legend_low_coverage],
        loc="lower center",
        bbox_to_anchor=(0.5, 0.19),
        ncol=2,
        frameon=False,
        fontsize=8.5,
        handlelength=1.4,
        columnspacing=1.8
    )

    fig.text(
        0.5,
        0.07,
        "Each block represents one target interval from the BED file. Widths are not shown to genomic scale.",
        ha="center",
        va="center",
        fontsize=8,
        color="#555555"
    )

    plt.savefig(out_plot, bbox_inches="tight", dpi=300, pad_inches=0.25)
    plt.close()


# Main execution
bed_df = read_bed_file(BED_TARGET)
gaps_df = read_gaps_file(GAPS_TSV)

plot_target_regions(
    bed_df=bed_df,
    gaps_df=gaps_df,
    out_plot=OUT_PLOT
)