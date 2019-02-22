From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V4 0/4] Add support for TCG2 event logs on EFI systems
Date: Fri, 22 Feb 2019 12:26:02 -0800
Message-ID: <20190222202606.160816-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-integrity@vger.kernel.org
Cc: peterhuewe@gmx.de, jarkko.sakkinen@linux.intel.com, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com
List-Id: linux-efi@vger.kernel.org

This patchset adds support for obtaining the TCG2 format event log on
EFI systems, along with support for copying up the final event log to
capture events that occur after the primary log is obtained. V4 is
identical to previous versions, except for tpm_read_log_efi() in patch 3
being reworked to reduce nesting.
