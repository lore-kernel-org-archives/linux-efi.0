Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36820432E93;
	Mon, 10 Aug 2026 17:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786383547; cv=none; b=EPw2vKgvNtK0I+N1N1jPpEzVrg9EM1HBqbBfpQn4cNBE64eNbLzZ3phNHZr1yzaVUGbaxyZSyiWsRZStlJph85+BBxqJdVa+nFmJTORZOwWizITq3KFYpgIXUv0H9zo3cx8P+CXLBmC6hCarrDDPLcA4tO7Z+3nEDwyaLp+mo9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786383547; c=relaxed/simple;
	bh=Fy+B1k2FCnaKIoHjyoxcd0duChUWH6ux2biCUHj4zP8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iyRL6IfXckzIxD64R3T8uG67kwXII8/uZazwxHZ8mkj8ajjdkdlzO7ra92ArGol57G+NxzaXUiGij7kbq3HFndurJAB6Ie0h1Rkv2kEvC9Kn9or98M3nsfRF6YsFd2j3PNARLfkiuQKEFVHWm5dHk1ARarwhHdFYpNMVA0ZRoKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XwJWbYMf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XwJWbYMf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F51B1F00A3A;
	Mon, 10 Aug 2026 17:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786383545;
	bh=jk4/iqf3QlrsL8m2XoV0Xf9bF4tI4hIm7T5gSdo0XHA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=XwJWbYMflVEGgLIja1EWAoDBtXPLApa/NkhtMQDGRnVjjt8ci9J1uJS4baCLClDhH
	 JhCTVMEaM4RnoWd5AE7v1RSt4+WHhsIMue+11gnSAPlkTWA3jsm/MztKnqM9HYEeYg
	 F3HSfe9YPb6L13yci31ejGgFbBoYJK2sLluFBiRbBIi3K1112oKRwXmMH8XCDjiNUL
	 O4zDHyOMnNvMLmr5Ff9Bj2+8yk4LsoiqXXgEIHKDsq6F5hm/JS2p/xGzzmlILvoWnP
	 Ji1fJM1uOHgWg47TYrlX+f49ixOfpnWV5UxPoLlXiAw19dKwWcQVnkKgo3rIGsRrsP
	 InFqbiVqMUrdg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: George Guo <dongtai.guo@linux.dev>,  rppt@kernel.org,
  pasha.tatashin@soleen.com,  pratyush@kernel.org,  shuah@kernel.org,
  ardb@kernel.org,  guodongtai@kylinos.cn,  kernel@xen0n.name,
  graf@amazon.com,  loongarch@lists.linux.dev,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kselftest@vger.kernel.org,
  linux-efi@vger.kernel.org,  Kexin Liu <liukexin@kylinos.cn>
Subject: Re: [PATCH v4 3/4] liveupdate: luo_session: include linux/mm.h for
 virt/phys translation
In-Reply-To: <CAAhV-H4pK10ONo=viJyUJBiiFb_7pbB9LaNkQWH=83r+7E0iTA@mail.gmail.com>
	(Huacai Chen's message of "Mon, 10 Aug 2026 22:37:25 +0800")
References: <20260807103714.33074-1-dongtai.guo@linux.dev>
	<20260807103714.33074-4-dongtai.guo@linux.dev>
	<CAAhV-H4pK10ONo=viJyUJBiiFb_7pbB9LaNkQWH=83r+7E0iTA@mail.gmail.com>
Date: Mon, 10 Aug 2026 19:39:01 +0200
Message-ID: <2vxzjypx6fka.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 10 2026, Huacai Chen wrote:

> Hi, George,
>
> This should be the 2nd patch.

Agreed.

With that done,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>
> Huacai
>
> On Fri, Aug 7, 2026 at 6:39=E2=80=AFPM George Guo <dongtai.guo@linux.dev>=
 wrote:
>>
>> From: George Guo <guodongtai@kylinos.cn>
>>
>> luo_session.c calls virt_to_phys() and phys_to_virt(). On LoongArch with
>> CONFIG_KFENCE=3Dy, these macros (in arch/loongarch/include/asm/io.h) exp=
and
>> to offset_in_page() and page_address(), both declared in <linux/mm.h>.
>>
>> Since luo_session.c only includes <linux/io.h>, the translation unit fai=
ls
>> to build with CONFIG_KFENCE=3Dy:
>>
>>   asm/io.h: error: implicit declaration of function 'offset_in_page'
>>   asm/io.h: error: implicit declaration of function 'page_address'
>>
>> Add the missing include to fix these build errors.
>>
>> Co-developed-by: Kexin Liu <liukexin@kylinos.cn>
>> Signed-off-by: Kexin Liu <liukexin@kylinos.cn>
>> Signed-off-by: George Guo <guodongtai@kylinos.cn>
>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>> ---
>>  kernel/liveupdate/luo_session.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_ses=
sion.c
>> index f38b5b18f3f8..31490ac7b63d 100644
>> --- a/kernel/liveupdate/luo_session.c
>> +++ b/kernel/liveupdate/luo_session.c
>> @@ -94,6 +94,7 @@
>>  #include <linux/kho/abi/luo.h>
>>  #include <linux/list.h>
>>  #include <linux/liveupdate.h>
>> +#include <linux/mm.h>
>>  #include <linux/mutex.h>
>>  #include <linux/rwsem.h>
>>  #include <linux/slab.h>
>> --
>> 2.53.0
>>
>>

--=20
Regards,
Pratyush Yadav
