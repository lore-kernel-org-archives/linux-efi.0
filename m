From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: Re: [PATCH 09/13] ARM: Xen: Initialize Xen specific
 UEFI runtime services
Date: Tue, 17 Nov 2015 20:17:35 +0800
Message-ID: <564B1ADF.70105@huawei.com>
References: <1447754231-7772-1-git-send-email-shannon.zhao@linaro.org>	<1447754231-7772-10-git-send-email-shannon.zhao@linaro.org>
	<CAKv+Gu9-g6fttchWkg_ptCGwUD-hbyM2F0x1Wrv=dAa6bsMVBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
In-Reply-To: <CAKv+Gu9-g6fttchWkg_ptCGwUD-hbyM2F0x1Wrv=dAa6bsMVBQ@mail.gmail.com>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Shannon Zhao <shannon.zhao@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Hangaohuai <hangaohuai@huawei.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Ian Campbell <ian.campbell@citrix.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, "Huangpeng (Peter)" <peter.huangpeng@huawei.com>, "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>, Julien Grall <julien.grall@citrix.com>, Stefano Stabellini <stefano.stabellini@citrix.com>, Christoffer Dall <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org



On 2015/11/17 19:28, Ard Biesheuvel wrote:
>> @@ -308,13 +311,18 @@ static int __init arm64_enable_runtime_services(void)
>> >         }
>> >         set_bit(EFI_SYSTEM_TABLES, &efi.flags);
>> >
>> > -       if (!efi_virtmap_init()) {
>> > -               pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
>> > -               return -1;
>> > -       }
>> > +       if (!xen_initial_domain()) {
>> > +               if (!efi_virtmap_init()) {
>> > +                       pr_err("No UEFI virtual mapping was installed -- runtime services will not be available\n");
>> > +                       return -1;
>> > +               }
>> >
> I'd prefer it if we could separate the code logically, rather than
> putting xen_initial_domain() tests in all the code paths.
> 
> For instance, we could re-use the EFI_PARAVIRT flag, and set if from
> the Xen init code. Then, we could simply test it here, and bail early.
> That way, you can have a Xen specific alternative (which does not use
> the virtmap etc anyway) in a xen source file.
> 
Ok, will do. Thanks.

-- 
Shannon
