From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH V4 0/4] Add support for TCG2 event logs on EFI systems
Date: Tue, 26 Feb 2019 16:03:33 +0200
Message-ID: <61db64b184a6b409248f5debb8549d6011a8cdac.camel@linux.intel.com>
References: <20190222202606.160816-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190222202606.160816-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>, linux-integrity@vger.kernel.org
Cc: peterhuewe@gmx.de, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com
List-Id: linux-efi@vger.kernel.org

On Fri, 2019-02-22 at 12:26 -0800, Matthew Garrett wrote:
> This patchset adds support for obtaining the TCG2 format event log on
> EFI systems, along with support for copying up the final event log to
> capture events that occur after the primary log is obtained. V4 is
> identical to previous versions, except for tpm_read_log_efi() in patch 3
> being reworked to reduce nesting.

Looks good.

I'll re-try testing latter part of this weke.

/Jarkko
