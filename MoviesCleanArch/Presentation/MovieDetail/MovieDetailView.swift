//
//  MovieDetailView.swift
//  MoviesCleanArch
//
//  Created by Amr Magdy on 26/04/2026.
//

import SwiftUI
import Domain

struct MovieDetailView: View {
    @State var viewModel: MovieDetailViewModel

    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = viewModel.errorMessage {
                ErrorStateView(message: error) { await viewModel.retry() }
            } else if let detail = viewModel.detail {
                detailContent(detail)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private func detailContent(_ detail: MovieDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                CachedAsyncImage(url: detail.posterURL)
                    .frame(maxWidth: .infinity)
                    .frame(height: 420)
                    .clipped()

                VStack(alignment: .leading, spacing: 20) {
                    headerSection(detail)
                    Divider()
                    overviewSection(detail)
                    Divider()
                    infoSection(detail)
                }
                .padding(20)
            }
        }
        .navigationTitle(detail.title)
    }

    private func headerSection(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(detail.title)
                .font(.title2)
                .fontWeight(.bold)

            if !detail.releaseMonthYear.isEmpty {
                Text(detail.releaseMonthYear)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            if !detail.genres.isEmpty {
                Text(detail.genres.map(\.name).joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func overviewSection(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.headline)
            Text(detail.overview.isEmpty ? "No overview available." : detail.overview)
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
    }

    @ViewBuilder
    private func infoSection(_ detail: MovieDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Details")
                .font(.headline)

            InfoRow(label: "Status", value: detail.status.isEmpty ? "N/A" : detail.status)
            InfoRow(label: "Runtime", value: detail.formattedRuntime)
            InfoRow(label: "Budget", value: detail.formattedBudget)
            InfoRow(label: "Revenue", value: detail.formattedRevenue)

            if !detail.spokenLanguages.isEmpty {
                InfoRow(label: "Languages", value: detail.spokenLanguages.joined(separator: ", "))
            }

            if let homepage = detail.homepage, !homepage.isEmpty, let url = URL(string: homepage) {
                Divider()
                Link(destination: url) {
                    HStack {
                        Text("Homepage")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                    }
                    .foregroundStyle(Color.accentColor)
                }
            }
        }
    }
}
