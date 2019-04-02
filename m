From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH] TCG2 log support build fixes for non-x86_64
Date: Tue,  2 Apr 2019 14:55:54 -0700
Message-ID: <20190402215556.257406-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com
List-Id: linux-efi@vger.kernel.org

Couple of patches to fix ktest reported issues with the crypto-agile log
format support.
