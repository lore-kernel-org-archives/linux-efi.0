From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: Add support for TCG2 log format on UEFI systems
Date: Thu, 14 Mar 2019 11:35:15 +0200
Message-ID: <20190314093515.GA11165@linux.intel.com>
References: <20190227202658.197113-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190227202658.197113-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 27, 2019 at 12:26:54PM -0800, Matthew Garrett wrote:
> Identical to V4, but based on tpmdd-next

This is not found /sys/kernel/security/tpm0/ascii_bios_measurements

But still

[    0.000000] efi:  ACPI 2.0=0x69ca2000  ACPI=0x69ca2000  TPMFinalLog=0x69ce4000  SMBIOS=0x69f63000  SMBIOS 3.0=0x69f62000  ESRT=0x69f3e818  MEMATTR=0x63448018

Tried this with too machines now.

I wonder if anyone else has had success...

/Jarkko
