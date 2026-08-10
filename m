Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C0A432315;
	Mon, 10 Aug 2026 17:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786383895; cv=none; b=dGCKkxswgEGj2+4yzhsqRU+p5CZPr5CTOEJVPDeHo3BP4WBEGuVqZDyYewdVve0YlXgbYCrA8j5e4fDLAz6MeqT5kG6D87SJlwV7IM2lbCnl0iToiQ5V7ekp58TfH6A39zJGWbEFiVOwn/RtmNXqgdSQCVnkBP3O9uH6m+aEkXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786383895; c=relaxed/simple;
	bh=7d5arm4sONKjUAZwfzhFgGhw5Ewk/HRhTgKSncvL5ps=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=gCrnN6W2YM6zUcQJtnk5Qs3a48bcNtmyxbGATnscqqM0uffMAXPA8OPZo+difVq9e3njcJyRsKcW1pO/3KNkPbQEHSwv3nJyT3acNU/bMkcODtY4RdCZMCVUzStL5ACEUJGDdS7pqV8SRpcA0+gwqO0SJbrRSmGuxwajco+W5zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TDhG6LdU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TDhG6LdU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D551F000E9;
	Mon, 10 Aug 2026 17:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786383894;
	bh=MP2+23zFvL9Yev7WTv4ThtH3GwLxgP0jNN2O9q9lsco=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TDhG6LdU+xmaROsqFck3hBtm6iNfonUwi9trFk34RupcKybOSt6P84/qzbjudd9Wu
	 evlBRW4nJ4HD0cll3MkA8vYdh0GN1X0UBLa8kl7uNslZW5quVAfTSogtkkhWJqAYuj
	 j7BA3bAWZpBSUxiQmPhfKrlPUpF8ouMqV6yQJoBzflBNPbfXGT9B47IkJtk2usAEJb
	 5JCsFPUcg5MjoJAiS2uk3tAlrNLp3Vdpc70GQjFvauDt/Wta74NeZghnfO0ZnasdzM
	 QKHvsZnV5iWN4njlQb4AEJEqQEycrrAzS7XJi2Nk1PiIGxYlteW+dasD4OpI51JJA1
	 lga2SFv2CjFQA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Huacai Chen <chenhuacai@kernel.org>,  George Guo
 <dongtai.guo@linux.dev>,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  shuah@kernel.org,  ardb@kernel.org,  guodongtai@kylinos.cn,
  kernel@xen0n.name,  graf@amazon.com,  loongarch@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-efi@vger.kernel.org,  Kexin Liu <liukexin@kylinos.cn>
Subject: Re: [PATCH v4 3/4] liveupdate: luo_session: include linux/mm.h for
 virt/phys translation
In-Reply-To: <2vxzjypx6fka.fsf@kernel.org> (Pratyush Yadav's message of "Mon,
	10 Aug 2026 19:39:01 +0200")
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
	<20260807103714.33074-4-dongtai.guo@linux.dev>
	<CAAhV-H4pK10ONo=viJyUJBiiFb_7pbB9LaNkQWH=83r+7E0iTA@mail.gmail.com>
	<2vxzjypx6fka.fsf@kernel.org>
Date: Mon, 10 Aug 2026 19:44:49 +0200
Message-ID: <2vxzfr0l6fam.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10 2026, Pratyush Yadav wrote:

> On Mon, Aug 10 2026, Huacai Chen wrote:
>
>> Hi, George,
>>
>> This should be the 2nd patch.
>
> Agreed.
>
> With that done,
>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Actually, I take this back. Sashiko has found some problems. See below.

>
>>
>> Huacai
>>
>> On Fri, Aug 7, 2026 at 6:39=E2=80=AFPM George Guo <dongtai.guo@linux.dev=
> wrote:
>>>
>>> From: George Guo <guodongtai@kylinos.cn>
>>>
>>> luo_session.c calls virt_to_phys() and phys_to_virt(). On LoongArch with
>>> CONFIG_KFENCE=3Dy, these macros (in arch/loongarch/include/asm/io.h) ex=
pand
>>> to offset_in_page() and page_address(), both declared in <linux/mm.h>.

https://sashiko.dev/#/patchset/20260807103714.33074-5-dongtai.guo@linux.dev

    Is this description accurate? Looking at luo_session.c, it does not act=
ually
    call virt_to_phys().
    The implicit declaration error appears to originate from arch_kfence_in=
it_pool()
    in arch/loongarch/include/asm/kfence.h, which is implicitly included via
    <linux/slab.h>.
    arch/loongarch/include/asm/kfence.h:arch_kfence_init_pool() {
        ...
                    virt_to_phys((void *)kfence_pool), PAGE_KERNEL);
        ...
    }
    Could the fix be applied to the architecture header instead, to prevent=
 any
    other kernel C file on LoongArch with CONFIG_KFENCE=3Dy from suffering =
the same
    build failure if it includes <linux/slab.h> before <linux/mm.h>?

I at least don't see any virt_to_phys() or phys_to_virt() in
luo_session.c. So you need to go and take another look at what the real
problem is and what the fix should be.

>>>
>>> Since luo_session.c only includes <linux/io.h>, the translation unit fa=
ils
>>> to build with CONFIG_KFENCE=3Dy:
>>>
>>>   asm/io.h: error: implicit declaration of function 'offset_in_page'
>>>   asm/io.h: error: implicit declaration of function 'page_address'
>>>
>>> Add the missing include to fix these build errors.
>>>
>>> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
>>> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
>>> Signed-off-by: George Guo <guodongtai@kylinos.cn>
>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>  kernel/liveupdate/luo_session.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_se=
ssion.c
>>> index f38b5b18f3f8..31490ac7b63d 100644
>>> --- a/kernel/liveupdate/luo_session.c
>>> +++ b/kernel/liveupdate/luo_session.c
>>> @@ -94,6 +94,7 @@
>>>  #include <linux/kho/abi/luo.h>
>>>  #include <linux/list.h>
>>>  #include <linux/liveupdate.h>
>>> +#include <linux/mm.h>
>>>  #include <linux/mutex.h>
>>>  #include <linux/rwsem.h>
>>>  #include <linux/slab.h>
>>> --
>>> 2.53.0
>>>
>>>

--=20
Regards,
Pratyush Yadav
