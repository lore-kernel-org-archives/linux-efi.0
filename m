From: Christopher Li <sparse@chrisli.org>
Subject: Re: [efi:next 2/3] arch/x86/boot/compressed/eboot.c:26:16: sparse:
 incorrect type in return expression (different modifiers)
Date: Mon, 17 Nov 2014 23:35:46 +0800
Message-ID: <CANeU7QkZKv+c1y-_9DsvV-EqKnmm+NjUEGxhZBqSF_5AJ+XT1g@mail.gmail.com>
References: <201411120724.PdeIjimc%fengguang.wu@intel.com>
	<CAKv+Gu8Jk4z6Q+8ZstNrA5e0ictYnzq9XOeq8zbr8ADo5DyWow@mail.gmail.com>
	<1415799312.14686.332.camel@mfleming-mobl1.ger.corp.intel.com>
	<CANeU7Qn8J2dn4V5Mx1WzUM9q+m=K66yUuEkN39bH_djRoBzqNA@mail.gmail.com>
	<CAKv+Gu-L2EoqioZamh9arLSkXzQF4y=FDykk0YK1XvNkRGC-xg@mail.gmail.com>
	<CANeU7Q=6mB2yoSy9PpnNjeYcvvzD8DEUyyeXQhW2YE2aSGq_gg@mail.gmail.com>
	<CAKv+Gu8DB6tCrpTqiCSWDGU4cRO1u3hqO9-K-cON5ODDMgsx1Q@mail.gmail.com>
	<CANeU7Qmo4t42N6A7ktB9GL2Ho0K9RqkJq3g0jn7s-qb5V2Ly9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-sparse-owner@vger.kernel.org>
In-Reply-To: <CANeU7Qmo4t42N6A7ktB9GL2Ho0K9RqkJq3g0jn7s-qb5V2Ly9Q@mail.gmail.com>
Sender: linux-sparse-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Matt Fleming <matt.fleming@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux-Sparse <linux-sparse@vger.kernel.org>, "fengguang.wu" <fengguang.wu@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Nov 17, 2014 at 8:38 AM, Christopher Li <sparse@chrisli.org> wrote:
> I see. Thanks for the review. So the above case should not raise
> error. However, the following one should:
>
> static __pure void *(*f3_err) = non_pure_func;
>
> I got it the other way around. I will add that to the test case
> and send out the second round review.

I send push out the v2 version of the test case at
https://git.kernel.org/cgit/devel/sparse/chrisl/sparse.git/log/?h=review-pure-attr2

I haven't include the fix part yet. Do you see any thing wrong with the test
case?

Thanks

Chris
