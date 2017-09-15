From: Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [RFC Part1 PATCH v3 13/17] x86/io: Unroll string I/O when SEV is
 active
Date: Fri, 15 Sep 2017 09:13:00 -0500
Message-ID: <95314c89-2620-8bb7-cbe8-cd9bc3adabb0@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
 <20170724190757.11278-14-brijesh.singh@amd.com>
 <063D6719AE5E284EB5DD2968C1650D6DD003FB85@AcuExch.aculab.com>
 <CAK8P3a3h7JpmkW7W=HwqAuWWmro=ngj6HSeiiML_=T82x-FtZQ@mail.gmail.com>
 <ed6d4ce7-97a6-f664-d7d7-4ff48bc6f06a@amd.com>
 <201707261927.v6QJR228008075@mail.zytor.com>
 <589d65a4-eb09-bae9-e8b4-a2d78ca6b509@amd.com>
 <20170822165248.rkbluikdgduu7ucy@pd.tnic>
 <20170915122430.pnroy6vsg53warel@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170915122430.pnroy6vsg53warel@pd.tnic>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>
Cc: brijesh.singh@amd.com, "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>, David Laight <David.Laight@aculab.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Paul Mackerras <paulus@samba.org>, Christoph Lameter <cl@linux.com>, Jonathan Corbet <corbet@lwn.net>, =?UTF-8?Q?Radim_Krcm=c3=a1r?= <rkrcmar@redhat.com>, Piotr Luc <piotr.luc@intel.com>, Ingo Molnar <mingo@redhat.com>, Dave Airlie <airlied@redhat.com>
List-Id: linux-efi@vger.kernel.org



On 09/15/2017 07:24 AM, Borislav Petkov wrote:
> On Tue, Aug 22, 2017 at 06:52:48PM +0200, Borislav Petkov wrote:
>> As always, the devil is in the detail.
> 
> Ok, actually we can make this much simpler by using a static key. A
> conceptual patch below - I only need to fix that crazy include hell I'm
> stepping into with this.
> 
> In any case, we were talking about having a static branch already so
> this fits the whole strategy.
> 

thanks for the suggestion Boris, it will make patch much simpler.
I will try this out.

-Brijesh
