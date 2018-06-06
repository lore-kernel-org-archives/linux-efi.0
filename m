From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: Do Qualcomm drivers use DMA buffers for
 request_firmware_into_buf()?
Date: Thu, 7 Jun 2018 00:55:22 +0200
Message-ID: <20180606225522.GL4511@wotan.suse.de>
References: <20180424234219.GX14440@wotan.suse.de>
 <1524632409.3371.48.camel@linux.vnet.ibm.com>
 <20180425175557.GY14440@wotan.suse.de>
 <CAB0TPYGnCu+anWHBGvkaigxD--8uHQaQJ2c62kegJ7mTqvkmnA@mail.gmail.com>
 <20180508153805.GC27853@wotan.suse.de>
 <20180601192346.GQ4511@wotan.suse.de>
 <20180606203257.GH4511@wotan.suse.de>
 <CAKv+Gu9+rLxoocCGkB7tRi03jkyPoQ5tX5bTN9C6A4iFj20mgQ@mail.gmail.com>
 <20180606222929.GK4511@wotan.suse.de>
 <CAKv+Gu_AYCmEzfSoXfgJ2RbAfuadsBYWXuZdpTvCtJT3btzW4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_AYCmEzfSoXfgJ2RbAfuadsBYWXuZdpTvCtJT3btzW4w@mail.gmail.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Matt Fleming <matt@codeblueprint.co.uk>, Will Deacon <will.deacon@arm.com>, Michal Hocko <mhocko@kernel.org>, David Howells <dhowells@redhat.com>, David Brown <david.brown@linaro.org>, Peter Jones <pjones@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>, Nicolas Broeking <nbroeking@me.com>, Jonathan Corbet <corbet@lwn.net>, the arch/x86 maintainers <x86@kernel.org>, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>, Ingo Molnar <mingo@redhat.com>, Kalle Valo <kvalo@codeaurora.org>, Andy Gross <andy.gross@linaro.org>, Darren Hart <dvhart@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, platform-driver-x86@vger.kernel.org, Arend Van Spriel <arend.vanspriel@broadcom.com>, Todd Kjos <tkjos@android.com>, Kees Cook <keescook@ch>
List-Id: linux-efi@vger.kernel.org

On Thu, Jun 07, 2018 at 12:41:12AM +0200, Ard Biesheuvel wrote:
> On 7 June 2018 at 00:29, Luis R. Rodriguez <mcgrof@kernel.org> wrote:
> > Given no one is providing a clear answer, and we cannot easily describe the
> > buffer at run time we'll just move forward with READING_FIRMWARE_DMA_COHERENT.
> 
> I seriously wonder whether the QCOM code cannot switch to the
> streaming API instead. That is generally preferred anyway (for
> performance, although that should not matter for loading firmware) but
> also removes this single wart for which we have to invent new flags
> and new security code plus the associated validation overhead.

Given 1 month and no response I don't think we can count on that at this point.

  Luis

-- 
Do not panic
