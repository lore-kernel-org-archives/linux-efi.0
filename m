From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 2/2] tpm: Fix builds on platforms that lack
 early_memremap()
Date: Thu, 4 Apr 2019 15:40:34 +0300
Message-ID: <20190404124034.GB14738@linux.intel.com>
References: <20190402215556.257406-1-matthewgarrett@google.com>
 <20190402215556.257406-3-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190402215556.257406-3-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 02, 2019 at 02:55:56PM -0700, Matthew Garrett wrote:
> On EFI systems, __calc_tpm2_event_size() needs to be able to map tables
> at early boot time in order to extract information from them.
> Unfortunately this interacts badly with other architectures that don't
> provide the early_memremap() interface but which may still have other
> mechanisms for obtaining crypto-agile logs. Abstract this away so we
> can avoid the need for two implementations while still avoiding breakage
> on architectures that don't require remapping of the table.
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
