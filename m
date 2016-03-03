From: Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v13 4/6] arm64: Move unflatten_device_tree() call earlier.
Date: Thu, 3 Mar 2016 07:47:51 -0600
Message-ID: <CAL_JsqL0Mzgp_SkycmiZBbt2OoGtE7_rFgD41Jex4nDS7xXrHA@mail.gmail.com>
References: <1456959362-2036-1-git-send-email-ddaney.cavm@gmail.com> <1456959362-2036-5-git-send-email-ddaney.cavm@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456959362-2036-5-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Daney <ddaney.cavm@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Frank Rowand <frowand.list@gmail.com>, Grant Likely <grant.likely@linaro.org>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Ganapatrao Kulkarni <gkulkarni@caviumnetworks.com>, Robert Richter <rrichter@cavium.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, David Daney <david.daney@cavium.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Mar 2, 2016 at 4:56 PM, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
>
> In order to extract NUMA information from the device tree, we need to
> have the tree in its unflattened form.
>
> Move the call to unflatten_device_tree() into paging_init().  This
> puts it before the call to bootmem_init(), which is where the NUMA
> information is extracted.

Can't you just move up unflatten_device_tree in setup_arch rather than
hiding in paging_init?

> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  arch/arm64/kernel/setup.c | 7 +++----
>  arch/arm64/mm/mmu.c       | 5 +++++
>  2 files changed, 8 insertions(+), 4 deletions(-)
