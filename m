From: Martijn Coenen <maco@android.com>
Subject: Re: [PATCH v3 2/5] efi: Add embedded peripheral firmware support
Date: Fri, 4 May 2018 12:44:37 -0700
Message-ID: <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
References: <20180408174014.21908-1-hdegoede@redhat.com>
 <20180408174014.21908-3-hdegoede@redhat.com>
 <20180423211143.GZ14440@wotan.suse.de>
 <71e6a45a-398d-b7a4-dab0-8b9936683226@redhat.com>
 <1524586021.3364.20.camel@linux.vnet.ibm.com>
 <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180425175557.GY14440@wotan.suse.de>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: dmitry.torokhov@gmail.com, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, platform-driver-x86@vger.kernel.org, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, nbroeking@me.com, x86@kernel.org, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, Ingo Molnar <mingo@redhat.com>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees Cook <keescook@chromium.org>, linux-efi <linux-efi@vger.kernel.org>, linux-arm-msm@vger.kernel.org, Torsten Duwe <duwe@suse.de>, Josh Triplett <josh@joshtriplett.org>, Chris Wright <chrisw@sous-sol.org>, Hans de Goede <hdego>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 25, 2018 at 10:55 AM, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> Android became the primary user of CONFIG_FW_LOADER_USER_HELPER_FALLBACK.
>
> It would be good for us to hear from Android folks if their current use of
> request_firmware_into_buf() is designed in practice to *never* use the direct
> filesystem firmware loading interface, and always rely instead on the
> fallback mechanism.

It's hard to answer this question for Android in general. As far as I
can tell the reasons we use CONFIG_FW_LOADER_USER_HELPER(_FALLBACK)
are:
1) We have multiple different paths on our devices where firmware can
be located, and the direct loader only supports one custom path
2) Most of those paths are not mounted by the time the corresponding
drivers are loaded, because pretty much all Android kernels today are
built without module support, and therefore drivers are loaded well
before the firmware partition is mounted
3) I think we use _FALLBACK because doing this with uevents is just
the easiest thing to do; our init code has a firmware helper that
deals with this and searches the paths that we care about

2) will change at some point, because Android is moving towards a
model where device-specific peripheral drivers will be loaded as
modules, and since those modules would likely come from the same
partition as the firmware, it's possible that the direct load would
succeed (depending on whether the custom path is configured there or
not). But I don't think we can rely on the direct loader even in those
cases, unless we could configure it with multiple custom paths.

I have no reason to believe request_firmware_into_buf() is special in
this regard; drivers that depend on it may have their corresponding
firmware in different locations, so just depending on the direct
loader would not be good enough.

>
> Is ptr below
>
>         ret = request_firmware_into_buf(&seg_fw, fw_name, dev,
>                                         ptr, phdr->p_filesz);
>
> Also part of the DMA buffer allocated earlier via:
>
>         ret = qcom_scm_pas_init_image(pas_id, fw->data, fw->size);
>
> Android folks?

I think the Qualcomm folks owning this (Andy, David, Bjorn, already
cc'd here) are better suited to answer that question.

Thanks,
Martijn
