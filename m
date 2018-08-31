From: Guillaume Tucker <guillaume.tucker@collabora.com>
Subject: Re: [PATCH 4.4 103/105] Revert "x86/mm/pat: Ensure cpa->pfn only
 contains page frame numbers"
Date: Fri, 31 Aug 2018 07:24:08 +0100
Message-ID: <5dd63596-9f7f-f72a-37ad-b0d97580667e@collabora.com>
References: <20171215092305.994559179@linuxfoundation.org>
 <20171215092311.347628971@linuxfoundation.org>
 <CAL1RGDVgShymmT+TJ3mAHEL7n+qoisk6mQ=Tji_T=0d_QA=VKw@mail.gmail.com>
 <1535129126.2902.36.camel@codethink.co.uk>
 <CAL1RGDW1Lo+F5D479Jsi-AFsmjVpdDre_qOFSCwWubG6U=bxeQ@mail.gmail.com>
 <20180824191749.GA15489@kroah.com>
 <CAL1RGDXUx-frpWuuYyc-VrAEoOU2+irGQPRWvoBzO2ZxEPGrww@mail.gmail.com>
 <20180824201025.GB18715@roeck-us.net>
 <CAL1RGDXa2POjmrr8UK-2oYyQtxYxiOs5t9BrpGUHRXqkDjMW5w@mail.gmail.com>
 <20180824203251.GD18715@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180824203251.GD18715@roeck-us.net>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Guenter Roeck <linux@roeck-us.net>, Roland Dreier <roland@purestorage.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ben Hutchings <ben.hutchings@codethink.co.uk>, LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org, matt@codeblueprint.co.uk, bp@suse.de, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, luto@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, bp@alien8.de, brgerst@gmail.com, davej@codemonkey.org.uk, dvlasenk@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, sai.praneeth.prakhya@intel.com, sds@tycho.nsa.gov, Thomas Gleixner <tglx@linutronix.de>, toshi.kani@hp.com, linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Yazen.Ghannam@amd.com
List-Id: linux-efi@vger.kernel.org

On 24/08/18 21:32, Guenter Roeck wrote:
> On Fri, Aug 24, 2018 at 01:16:18PM -0700, Roland Dreier wrote:
>>> Sounds great. I'll hold off with sending my RFT series and wait for your
>>> test results. I think we'll also need d367cef0a7f0c6 ("x86/mm/pat: Fix
>>> boot crash when 1GB pages are not supported by the CPU").
>>
>> Sure, makes sense - I don't have any EFI systems with CPUs old enough
>> not to support 1G pages but that looks reasonable.  I'll pull that
>> into my tree as well.
>>
> kernelci reported a crash on a CPU which doesn't support 1G pages.
> See https://kernelci.org/boot/id/5b7d39ea59b514c03796ba9c/

Looks like this has now been fixed with Andi's patch in 4.4.153:

  "x86/mm/pat: Fix L1TF stable backport for CPA"

I can confirm this platform is now booting fine in kernelci:

  http://lava.streamtester.net/scheduler/job/146195

Thanks,
Guillaume
