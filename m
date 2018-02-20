From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] fix double ;;s in code
Date: Tue, 20 Feb 2018 08:41:10 -0800
Message-ID: <1519144870.4326.7.camel@perches.com>
References: <20180217211955.GE9640@amd>
 <187435d4-5017-edb5-9b6a-b433a148bfcc@c-s.fr>
 <20180219154135.GV22199@phenom.ffwll.local>
 <87vaesrxn0.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org>
In-Reply-To: <87vaesrxn0.fsf@concordia.ellerman.id.au>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-snps-arc/>
List-Post: <mailto:linux-snps-arc@lists.infradead.org>
List-Help: <mailto:linux-snps-arc-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-snps-arc>,
 <mailto:linux-snps-arc-request@lists.infradead.org?subject=subscribe>
Sender: "linux-snps-arc" <linux-snps-arc-bounces@lists.infradead.org>
Errors-To: linux-snps-arc-bounces+gla-linux-snps-arc=m.gmane.org@lists.infradead.org
To: Michael Ellerman <mpe@ellerman.id.au>, Daniel Vetter <daniel@ffwll.ch>, Christophe LEROY <christophe.leroy@c-s.fr>
Cc: daniel.lezcano@linaro.org, heiko@sntech.de, narmstrong@baylibre.com, airlied@linux.ie, benh@kernel.crashing.org, linus.walleij@linaro.org, Alexey.Brodkin@synopsys.com, will.deacon@arm.com, fbarrat@linux.vnet.ibm.com, kernel list <linux-kernel@vger.kernel.org>, paulus@ozlabs.org, yamada.masahiro@socionext.com, mhocko@suse.com, viresh.kumar@linaro.org, Pavel Machek <pavel@ucw.cz>, hpa@zytor.com, JinHuiEric.Huang@amd.com, Rex.Zhu@amd.com, elfring@users.sourceforge.net, scott.bauer@intel.com, David1.Zhou@amd.com, architt@codeaurora.org, linux-arm-kernel@lists.infradead.org, joro@8bytes.org, x86@kernel.org, Wenjing.Liu@amd.com, linux@armlinux.org.uk, amd-gfx@lists.freedesktop.org, Ding.Wang@amd.com, aik@ozlabs.ru, wens@csie.org, mingo@redhat.com, vbabka@suse.cz, catalin.marinas@arm.com, airlied@redhat.com, ruscur@russell.cc, shli@kernel.org, dan.carpenter@oracle.com, andresx7@
List-Id: linux-efi@vger.kernel.org

On Tue, 2018-02-20 at 17:19 +1100, Michael Ellerman wrote:
> Daniel Vetter <daniel@ffwll.ch> writes:
> > On Sun, Feb 18, 2018 at 11:00:56AM +0100, Christophe LEROY wrote:
> > > Le 17/02/2018 =E0 22:19, Pavel Machek a =E9crit :
> > > > =

> > > > Fix double ;;'s in code.
> > > > =

> > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > =

> > > A summary of the files modified on top of the patch would help unders=
tand
> > > the impact.
> > > =

> > > A maybe there should be one patch by area, eg one for each arch speci=
fic
> > > modif and one for drivers/ and one for block/ ?
> > =

> > Yeah, pls split this into one patch per area, with a suitable patch
> > subject prefix. Look at git log of each file to get a feeling for what's
> > the standard in each area.
> =

> This part is actually pretty annoying.
> =

> I hacked up a script (below) which seems to do a reasonable job in most
> cases.

Here was another suggestion from awhile ago
https://lkml.org/lkml/2010/11/16/245
