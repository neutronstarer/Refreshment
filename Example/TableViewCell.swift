//
//  TableViewCell.swift
//  Example
//
//  Created by neutronstarer on 2021/11/2.
//

import UIKit

class TableViewCell: UITableViewCell {

    let label: UILabel = {
        let v = UILabel()
        v.textColor = .black
        v.font = UIFont.systemFont(ofSize: 18)
        v.numberOfLines = 0
        return v
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(contentView).offset(8)
            make.trailing.equalTo(contentView).offset(-8)
            make.top.equalTo(contentView).offset(8)
            make.bottom.equalTo(contentView).offset(-8).priorityLow()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
