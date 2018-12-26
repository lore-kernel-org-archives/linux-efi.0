From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH -mmotm] efi: drop kmemleak_ignore() for page allocator
Date: Wed, 26 Dec 2018 10:13:25 -0500
Message-ID: <403405f1-b702-2feb-4616-35fc3dc3133e@lca.pw>
References: <20181226023534.64048-1-cai@lca.pw>
 <CAKv+Gu_fiEDffKq_fONBYTOdSk-L7__+LgNEyVaNF3FGzBfAow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_fiEDffKq_fONBYTOdSk-L7__+LgNEyVaNF3FGzBfAow@mail.gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Ingo Molnar <mingo@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Linux-MM <linux-mm@kvack.org>, linux-efi <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On 12/26/18 7:02 AM, Ard Biesheuvel wrote:
> On Wed, 26 Dec 2018 at 03:35, Qian Cai <cai@lca.pw> wrote:
>>
>> a0fc5578f1d (efi: Let kmemleak ignore false positives) is no longer
>> needed due to efi_mem_reserve_persistent() uses __get_free_page()
>> instead where kmemelak is not able to track regardless. Otherwise,
>> kernel reported "kmemleak: Trying to color unknown object at
>> 0xffff801060ef0000 as Black"
>>
>> Signed-off-by: Qian Cai <cai@lca.pw>
> 
> Why are you sending this to -mmotm?
> 
> Andrew, please disregard this patch. This is EFI/tip material.

Well, I'd like to primarily develop on the -mmotm tree as it fits in a
sweet-spot where the mainline is too slow and linux-next is too chaotic.

The bug was reproduced and the patch was tested on -mmotm. If for every bugs
people found in -mmtom, they have to check out the corresponding sub-system tree
and reproduce/verify the bug over there, that is quite a burden to bear.

That's why sub-system maintainers are copied on those patches, so they can
decide to fix directly in the sub-system tree instead of -mmotm, and then it
will propagate to -mmotm one way or another.
