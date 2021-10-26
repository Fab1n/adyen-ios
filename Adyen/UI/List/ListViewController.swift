//
// Copyright (c) 2021 Adyen N.V.
//
// This file is open source and available under the MIT license. See the LICENSE file for more info.
//

import SwiftUI
import UIKit

/// Displays a list from which items can be selected.
/// :nodoc:
public final class ListViewController: UITableViewController {
    
    /// Indicates the list view controller UI style.
    public let style: ViewStyle

    /// :nodoc:
    /// Delegate to handle different viewController events.
    public weak var delegate: ViewControllerDelegate?
    
    /// Initializes the list view controller.
    ///
    /// - Parameter style: The UI style.
    public init(style: ViewStyle) {
        self.style = style
        super.init(style: .grouped)
    }
    
    /// :nodoc:
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// :nodoc:
    override public var preferredContentSize: CGSize {
        get { tableView.contentSize }
        
        // swiftlint:disable:next unused_setter_value
        set { AdyenAssertion.assertionFailure(message: """
        PreferredContentSize is overridden for this view controller.
        getter - returns content size of scroll view.
        setter - no implemented.
        """) }
    }
    
    // MARK: - Data Source
    
    /// :nodoc:
    public var sections: [ListSection] { dataSource.sections }
    
    /// :nodoc:
    private lazy var dataSource: ListViewControllerDataSource = {
        if #available(iOS 13, *) {
            return DiffableDataSource(tableView: tableView, cellProvider: { [weak self] tableView, indexPath, _ in
                self?.dataSource.cell(for: tableView, at: indexPath)
            })
        } else {
            return CoreDataSource()
        }
    }()
    
    /// :nodoc:
    public func reload(newSections: [ListSection]) {
        dataSource.reload(newSections: newSections, tableView: tableView)
    }
    
    // MARK: - View
    
    /// :nodoc:
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = style.backgroundColor
        tableView.backgroundColor = style.backgroundColor
        tableView.backgroundView?.backgroundColor = style.backgroundColor
        tableView.isOpaque = false
        
        tableView.separatorColor = .clear
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = 0.0
        tableView.estimatedRowHeight = 56.0
        tableView.register(ListCell.self, forCellReuseIdentifier: dataSource.cellReuseIdentifier)
        tableView.dataSource = dataSource

        delegate?.viewDidLoad(viewController: self)
    }

    /// :nodoc:
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.viewDidAppear(viewController: self)
    }
    
    // MARK: - UITableViewDelegate
    
    /// :nodoc:
    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = sections[section].header else {
            return nil
        }

        let headerView = ListHeaderView(title: header.title,
                                        trailingButtonTitle: sections[section].editingStyle == .delete ? "Edit" : nil,
                                        style: header.style)
        headerView.accessibilityIdentifier = ViewIdentifierBuilder.build(scopeInstance: "Adyen.ListViewController",
                                                                         postfix: "headerView.\(section)")
        headerView.onTrailingButtonTap = { [weak self] in
            self?.toggleEditingMode()
        }

        return headerView
    }
    
    private func toggleEditingMode() {
        var isEditingModeOn = tableView.isEditing
        isEditingModeOn.toggle()
        tableView.setEditing(isEditingModeOn, animated: true)
    }

    override public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let footer = sections[section].footer else {
            return nil
        }
        let footerView = ListFooterView(title: footer.title, style: footer.style)
        footerView.accessibilityIdentifier = ViewIdentifierBuilder.build(scopeInstance: "Adyen.ListViewController",
                                                                         postfix: "footerView.\(section)")
        return footerView
    }

    override public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        sections[section].footer == nil ? 0 : 55
    }
    
    /// :nodoc:
    override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        sections[section].header == nil ? 0 : 44.0
    }
    
    /// :nodoc:
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = sections[indexPath.section].items[indexPath.item]
        item.selectionHandler?()
    }
    
    /// :nodoc:
    override public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        sections[indexPath.section].editingStyle.tableViewEditingStyle
    }
    
    // MARK: - Item Loading state
    
    /// Starts a loading animation for a given ListItem.
    ///
    /// - Parameter item: The item to be shown as loading.
    public func startLoading(for item: ListItem) {
        dataSource.startLoading(for: item, tableView)
    }
    
    /// Stops all loading animations.
    public func stopLoading() {
        dataSource.stopLoading(tableView)
    }
    
}

extension EditinStyle {
    var tableViewEditingStyle: UITableViewCell.EditingStyle {
        switch self {
        case .delete:
            return .delete
        case .none:
            return .none
        }
    }
}
