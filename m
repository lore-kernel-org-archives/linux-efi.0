From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs
Date: Sat, 07 Dec 2013 13:46:33 -0800
Message-ID: <e42e2c5d-98cc-4375-8ff9-1448989fdb73@email.android.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
 <1385445477-9665-7-git-send-email-dyoung@redhat.com>
 <20131127114402.GB32267@pd.tnic>
 <20131129094034.GI4186@dhcp-16-126.nay.redhat.com>
 <20131129115029.GB4266@pd.tnic>
 <20131202025942.GF3999@dhcp-16-126.nay.redhat.com>
 <20131202094020.GA7380@pd.tnic>
 <2141297830.13051543.1386406862068.JavaMail.root@redhat.com>
 <20131207133048.GA4183@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
In-Reply-To: <20131207133048.GA4183-fF5Pk5pvG8Y@public.gmane.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/kexec/>
List-Post: <mailto:kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Help: <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/kexec>,
 <mailto:kexec-request-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org?subject=subscribe>
Sender: "kexec" <kexec-bounces-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
Errors-To: kexec-bounces+glkk-kexec=m.gmane.org-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

This is very good advice indeed.

Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org> wrote:
>On Sat, Dec 07, 2013 at 04:01:02AM -0500, Dave Young wrote:
>> Hi, all
>> 
>> Update my status:
>> 
>> I have finished most of thecode related changes including the
>krealloc
>> fixes (both for original code and my new code). And I'm slowly
>> moving the kexec related stuff to efi_kexec.c, this involves
>> some other cleanups, such as:
>> efi_systab_init:
>>  -> move 64bit code to efi_64.c, move 32bit code to efi_32.c
>> 
>> efi_setup global variable is changing to physical address,
>ioremapping
>> it when necessary instead of directly using the virt addr because
>> previously the virt addr will be freed until entering virtual mode,
>> it's possible a leak in case something is wrong in the middle also it
>> occupies the ioremap slot a little bit long.
>> 
>> There's also other problems, so I still need a few days probably
>> a week to carefully restructure the code.
>
>Those are all lofty goals but beware that trying to solve it all at
>once can be very painful and can cause unnecessary work for both coders
>and reviewers. Especially if the patchset grows out of proportion which
>makes it much harder to review and deal with.
>
>So, from my experience and if I were you, I'd try to address the most
>important issue I'm trying to fix, have 10ish nice clean patches and
>put
>the rest on the TODO list. This is much easier to deal with for
>everyone
>involved than trying to solve it all at once.
>
>Besides, if you solve it all at once, what are you going to work on
>afterwards? :-)
>
>HTH.

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
