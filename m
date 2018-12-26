From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH -mmotm] efi: drop kmemleak_ignore() for page allocator
Date: Wed, 26 Dec 2018 16:31:59 +0100
Message-ID: <CAKv+Gu_e=NkKZ5C+KzBmgg2VMXNKPqXcPON8heRd0F_iW+aaEQ@mail.gmail.com>
References: <20181226023534.64048-1-cai@lca.pw> <CAKv+Gu_fiEDffKq_fONBYTOdSk-L7__+LgNEyVaNF3FGzBfAow@mail.gmail.com>
 <403405f1-b702-2feb-4616-35fc3dc3133e@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <403405f1-b702-2feb-4616-35fc3dc3133e@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
To: Qian Cai <cai@lca.pw>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Linux-MM <linux-mm@kvack.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 26 Dec 2018 at 16:13, Qian Cai <cai@lca.pw> wrote:
>
> On 12/26/18 7:02 AM, Ard Biesheuvel wrote:
> > On Wed, 26 Dec 2018 at 03:35, Qian Cai <cai@lca.pw> wrote:
> >>
> >> a0fc5578f1d (efi: Let kmemleak ignore false positives) is no longer
> >> needed due to efi_mem_reserve_persistent() uses __get_free_page()
> >> instead where kmemelak is not able to track regardless. Otherwise,
> >> kernel reported "kmemleak: Trying to color unknown object at
> >> 0xffff801060ef0000 as Black"
> >>
> >> Signed-off-by: Qian Cai <cai@lca.pw>
> >
> > Why are you sending this to -mmotm?
> >
> > Andrew, please disregard this patch. This is EFI/tip material.
>
> Well, I'd like to primarily develop on the -mmotm tree as it fits in a
> sweet-spot where the mainline is too slow and linux-next is too chaotic.
>
> The bug was reproduced and the patch was tested on -mmotm. If for every bugs
> people found in -mmtom, they have to check out the corresponding sub-system tree
> and reproduce/verify the bug over there, that is quite a burden to bear.
>

Yes. But you know what? We all have our burden to bear, and shifting
this burden to someone else, in this case the subsystem maintainer who
typically deals with a sizable workload already, is not a very nice
thing to do.

> That's why sub-system maintainers are copied on those patches, so they can
> decide to fix directly in the sub-system tree instead of -mmotm, and then it
> will propagate to -mmotm one way or another.
>

Please stop sending EFI patches if you can't be bothered to
test/reproduce against the EFI tree.

Thanks,
Ard.
