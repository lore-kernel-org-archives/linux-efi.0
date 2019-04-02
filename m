From: Matthew Garrett <mjg59@google.com>
Subject: Re: [PATCH 0/4] Enabling secure boot on PowerNV systems
Date: Tue, 2 Apr 2019 14:51:14 -0700
Message-ID: <CACdnJusBm93zwDqTXTx_QYsg1-aGUAAHm_qq8Lcx3TvGTxdmbg@mail.gmail.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
 <CACdnJuumhkqTb4+1=QBiLmbW4xd3wW=MZu6Tj_KdaoTMhCN+Tg@mail.gmail.com> <4ce5e057-0702-b0d5-7bb2-cea5b22e2efa@linux.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4ce5e057-0702-b0d5-7bb2-cea5b22e2efa@linux.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Claudio Carvalho <cclaudio@linux.ibm.com>
Cc: linuxppc-dev@ozlabs.org, linux-efi <linux-efi@vger.kernel.org>, linux-integrity <linux-integrity@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, Paul Mackerras <paulus@samba.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Jeremy Kerr <jk@ozlabs.org>, Matthew Garret <matthew.garret@nebula.com>, Nayna Jain <nayna@linux.ibm.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Apr 2, 2019 at 2:11 PM Claudio Carvalho <cclaudio@linux.ibm.com> wrote:
> We want to use the efivarfs for compatibility with existing userspace
> tools. We will track and match any EFI changes that affect us.

So you implement the full PK/KEK/db/dbx/dbt infrastructure, and
updates are signed in the same way?

> Our use case is restricted to secure boot - this is not going to be a
> general purpose EFI variable implementation.

In that case we might be better off with a generic interface for this
purpose that we can expose on all platforms that implement a secure
boot key hierarchy. Having an efivarfs that doesn't allow the creation
of arbitrary attributes may break other existing userland
expectations.
