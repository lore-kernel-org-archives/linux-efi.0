From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH V4 2/4] tpm: Reserve the TPM final events table
Date: Wed, 27 Feb 2019 16:02:59 +0200
Message-ID: <20190227140259.GA17106@linux.intel.com>
References: <20190222202606.160816-1-matthewgarrett@google.com>
 <20190222202606.160816-3-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190222202606.160816-3-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthewgarrett@google.com>
Cc: linux-integrity@vger.kernel.org, peterhuewe@gmx.de, jgg@ziepe.ca, roberto.sassu@huawei.com, linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, tweek@google.com, Matthew Garrett <mjg59@google.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 22, 2019 at 12:26:04PM -0800, Matthew Garrett wrote:
> From: Matthew Garrett <mjg59@google.com>
> 
> UEFI systems provide a boot services protocol for obtaining the TPM
> event log, but this is unusable after ExitBootServices() is called.
> Unfortunately ExitBootServices() itself triggers additional TPM events
> that then can't be obtained using this protocol. The platform provides a
> mechanism for the OS to obtain these events by recording them to a
> separate UEFI configuration table which the OS can then map.
> 
> Unfortunately this table isn't self describing in terms of providing its
> length, so we need to parse the events inside it to figure out how long
> it is. Since the table isn't mapped at this point, we need to extend the
> length calculation function to be able to map the event as it goes
> along.
> 
> Signed-off-by: Matthew Garrett <mjg59@google.com>

Getting:

Applying: tpm: Reserve the TPM final events table
error: sha1 information is lacking or useless (drivers/firmware/efi/efi.c).
error: could not build fake ancestor

My tree:

git://git.infradead.org/users/jjs/linux-tpmdd.git

My guess is that your patches are based a later 5.0-rcX. Unfortunately I
cannot update my master at this point because my 5.1 PR was taken to
security tree and rebasing would change the commit IDs of 5.1 content
because security/next-general does not yet contain those patches.

/Jarkko
