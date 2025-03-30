//
//  ContentView.swift
//  DeCoder
//
//  Created by Christian Tashev on 3/29/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @StateObject private var viewModel = ConversionViewModel()
    @State private var showingRecentConversions = false
    @State private var showingExportSheet = false
    @State private var showingFileImporter = false
    @State private var exportText = ""
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Input Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Input Text")
                                .font(.headline)
                            Spacer()
                            Button(action: { showingFileImporter = true }) {
                                HStack {
                                    Image(systemName: "doc.badge.plus")
                                    Text("Import File")
                                }
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            }
                        }
                        TextField("Enter text to convert", text: $viewModel.inputText)
                            .textFieldStyle(.plain)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.systemBackground))
                                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)
                    
                    // Format Selection
                    FormatSelectionView(
                        selectedFormat: $viewModel.selectedFormat,
                        isReverse: $viewModel.isReverse,
                        caesarShift: $viewModel.caesarShift
                    )
                    .frame(height: 400)
                    
                    // Convert Button
                    Button(action: viewModel.convertText) {
                        HStack {
                            Image(systemName: viewModel.isReverse ? "arrow.triangle.2.circlepath" : "arrow.right")
                            Text(viewModel.isReverse ? "Decode" : "Encode")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    
                    // Progress View for file processing
                    if let progress = viewModel.conversionProgress {
                        VStack(spacing: 8) {
                            ProgressView(value: progress)
                                .progressViewStyle(.linear)
                            Text("Processing file...")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Output Section
                    if !viewModel.convertedText.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Converted Text")
                                    .font(.headline)
                                Spacer()
                                HStack(spacing: 16) {
                                    Button(action: viewModel.copyToClipboard) {
                                        Image(systemName: "doc.on.doc")
                                            .foregroundColor(.blue)
                                    }
                                    if viewModel.isProcessingFile {
                                        ShareLink(item: viewModel.convertedText) {
                                            Image(systemName: "square.and.arrow.up")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                }
                            }
                            
                            Text(viewModel.convertedText)
                                .font(.system(.body, design: .monospaced))
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6))
                                )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Recent Conversions and Export Buttons
                    if !viewModel.recentConversions.isEmpty {
                        HStack(spacing: 16) {
                            Button(action: { showingRecentConversions = true }) {
                                HStack {
                                    Image(systemName: "clock")
                                    Text("Recent")
                                }
                                .foregroundColor(.blue)
                            }
                            
                            Button(action: {
                                exportText = viewModel.exportConversions()
                                showingExportSheet = true
                            }) {
                                HStack {
                                    Image(systemName: "square.and.arrow.up")
                                    Text("Export History")
                                }
                                .foregroundColor(.blue)
                            }
                        }
                        .padding(.top)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("DeCoder")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isDarkMode.toggle() }) {
                        Image(systemName: isDarkMode ? "sun.max.fill" : "moon.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showingRecentConversions) {
                RecentConversionsView(conversions: viewModel.recentConversions)
            }
            .sheet(isPresented: $showingExportSheet) {
                NavigationStack {
                    ScrollView {
                        Text(exportText)
                            .font(.system(.body, design: .monospaced))
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                    }
                    .navigationTitle("Export Conversions")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            ShareLink(item: exportText)
                        }
                        ToolbarItem(placement: .topBarLeading) {
                            Button("Done") {
                                showingExportSheet = false
                            }
                        }
                    }
                }
            }
            .fileImporter(
                isPresented: $showingFileImporter,
                allowedContentTypes: FileManager.textTypes,
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    guard let url = urls.first else { return }
                    viewModel.processFile(url)
                case .failure(let error):
                    viewModel.errorMessage = error.localizedDescription
                    viewModel.showingError = true
                }
            }
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

struct RecentConversionsView: View {
    let conversions: [ConversionViewModel.Conversion]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(conversions) { conversion in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: conversion.format.icon)
                            .foregroundColor(.blue)
                        Text(conversion.format.rawValue)
                            .font(.headline)
                    }
                    
                    Text(conversion.input)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text(conversion.output)
                        .font(.system(.body, design: .monospaced))
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Recent Conversions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
