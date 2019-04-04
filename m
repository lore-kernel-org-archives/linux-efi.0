From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 1/2] efi: Fix cast to pointer from integer of different
 size in TPM log code
Date: Thu, 4 Apr 2019 15:39:51 +0300
Message-ID: <20190404123951.GA14738@linux.intel.com>
References: <20190402215556.257406-1-matthewgarrett@google.com>
 <20190402215556.257406-2-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190402215556.257406-2-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 02, 2019 at 02:55:55PM -0700, Matthew Garrett wrote:
> 8bfcff4a6a1d9d7226bb63a7da758b82d9ab4373 introduced a cast from
> efi_physical_address_t to (void *), which are different sizes on 32-bit.
> Fix that. Caught by the 0-day test bot.
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
