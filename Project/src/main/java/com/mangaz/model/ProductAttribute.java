package com.mangaz.model;

public class ProductAttribute {
    private String attributeName;
    private String valueText;

    public ProductAttribute() {
    }

    public ProductAttribute(String attributeName, String valueText) {
        this.attributeName = attributeName;
        this.valueText = valueText;
    }

    public String getAttributeName() {
        return attributeName;
    }

    public void setAttributeName(String attributeName) {
        this.attributeName = attributeName;
    }

    public String getValueText() {
        return valueText;
    }

    public void setValueText(String valueText) {
        this.valueText = valueText;
    }
}