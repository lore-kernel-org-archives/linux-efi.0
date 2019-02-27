From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH V4 2/4] tpm: Reserve the TPM final events table
Date: Wed, 27 Feb 2019 11:57:09 -0800
Message-ID: <CACdnJuucWezNf3jki5wN2XJ6wsN_uMSxQuyrekr9F-3aJJE4kA@mail.gmail.com>
References: <20190222202606.160816-1-matthewgarrett@google.com>
 <20190222202606.160816-3-matthewgarrett@google.com> <20190227140259.GA17106@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190227140259.GA17106@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: linux-integrity <linux-integrity@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>, Roberto Sassu <roberto.sassu@huawei.com>, linux-efi <linux-efi@vger.kernel.org>, LSM List <linux-security-module@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 27, 2019 at 6:03 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
> My guess is that your patches are based a later 5.0-rcX. Unfortunately I
> cannot update my master at this point because my 5.1 PR was taken to
> security tree and rebasing would change the commit IDs of 5.1 content
> because security/next-general does not yet contain those patches.

Bother. I'll rebase against your tree.
