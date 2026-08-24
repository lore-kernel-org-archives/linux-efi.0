Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A053AA9D1
	for <linux-efi@vger.kernel.org>; Mon, 24 Aug 2026 08:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787559606; cv=pass; b=dX5wj8j5hh435UMu5tAqn2wO3o9EPXpLiPUo8deSnAwasTZPnBbN173BsAALt8EjBXB3D4Kr64aDFXPfCfZl1QASdjzRm7rYmd57i0znF2l35cZlEtQw0nPGQ0kO8Kcyh3yqWklneKqmjTgA5G10z0UJg+k4ZN+R4rXFrsIRt3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787559606; c=relaxed/simple;
	bh=7XPvga+uRcgLueTQfvcZ8Uz0yiNdf2w9DTUvggwa/xI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=UxRfxV8JfQiEcyzy9ZYLzDpfwslhnj57TC9urPgVKEsMUPdsYlrspSOUzUoJEAlISKLL3+mCYNG30yGe9OjjFeEesRcXCzz77iT/PLax0rxjSFU/GJogeESEWIpijVpN+cxKdwAinpb8DhiNVA1OCuJEt0fshJEdAq2qbd+t3+g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lVND8f9E; arc=pass smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lVND8f9E"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-852ee3bb0c3so2950447b3.3
        for <linux-efi@vger.kernel.org>; Mon, 24 Aug 2026 01:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787559604; cv=none;
        d=google.com; s=arc-20260327;
        b=kw2corAnQ5ye4mLOzEg4TVr8UC2NDTRdFMVkHeH2qRZ6PRAluLWTSMaKWGQ6LzQYiL
         El0Rpn1qVA1FcwlBuebTx8w+oNMQ993dsNji4AppuzCrQPYKF7x9LjxldsMl85c7pGOH
         so/vvpCCXM5d7KtJVTBSwZ3proOON1fzv7FhlyoSmULnb5YoTySIo8/iWopyesOMCN7N
         JhXmmZubWfiIFeYFrXLsrx3Ulf+XpwYE7c3Bhmx0Wtg0xdLEjQAeanzBDEP7O59KCeJO
         uC/ccMrunLA6Hexfp/pYdHAfjYDs86Ts4w9BiVJL2vS6j3XD2M0uVNJDV8Z+PAHJgAY4
         Umpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7XPvga+uRcgLueTQfvcZ8Uz0yiNdf2w9DTUvggwa/xI=;
        fh=qKEmZ+KmFJfSFuU+XUFz41N+n1UL65LV+Zn0C4bZEgw=;
        b=bM2L654Ek1Dm2k6qDTr89j5fx72j5T0FWCx6Os/r5tkdaTx1BVfuyXAIM9DWn5D/Rz
         wO6DXk+lBVK4F8gbTUQU0u/PcsgC1i8z6roVVX+IP8iNLRS8tqknfpcS1owKy5hLHIIH
         D0pavuDuWQQCmA8LFPb6vCO6IjJmwpQoAToWZMVrmp/YjHCiEUlLnMMJm1MvDoJzwo5E
         eCxhesJ3nfL7JN8xmi5jHCZkb8331tuSb/wZgUXveWAr8e23uvaAcHShn7lpYdvzWyzh
         nntpuFwFQlxcFygGQY5vFLldrqR1ofmOnNOI84c6vdt/TdVdwRKo8pgZxoh0Qq1FTn9h
         7Ahw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787559604; x=1788164404; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7XPvga+uRcgLueTQfvcZ8Uz0yiNdf2w9DTUvggwa/xI=;
        b=lVND8f9E1tbKfWiiGuk3DrG/dFYM9yV9YqfWJOOgb8hQ+3mXt+nw9Ig0ubkSJrCrbC
         +WGy9ZPeK/oJqZ2Zp45tj2A4pDM8amZ0H9mmMIkXdbySQ38JlUO1azRZMx8VnLzgoBB4
         VsMnikZyTEEjxHFyYEDkVE9P3/zpF3sV9yULnABgED2R3zMUmd/mOO0u/c3K67Lt8ZAf
         l5TMI86jQZwSZm2GT7ytSRCTCaARCjQdiClxFo816XnV0TV/Z4+nL/5meMTvgrCczlPU
         CqYpyZTPnSIgK2b7YfcaZPeu3nJM8VwOD9bxPLw1MUT2kc/Qg6jibG/tOILaAHDh+z9q
         wAlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787559604; x=1788164404;
        h=content-transfer-encoding:content-type:to:subject:message-id:date
         :from:in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=7XPvga+uRcgLueTQfvcZ8Uz0yiNdf2w9DTUvggwa/xI=;
        b=lX0uw2S1GC2Hgxv2GGo7GvelxeZvj0b93c+j6GQDU1ZDQGqn6o81jMy8LIQ6Yw6lCL
         2KJ/WU01B1FNGghN1qI7tM0ief5O40Y7bRbgneynYWV6ctt3JFY3XqGJOmeEeyx93us6
         qJLJ2idTuN7vvpT8eSqDH7CTfJHytPlsspWbZsUIw045y0+cFsasP7en/RCfqPQhRNTW
         ZJeSGZwIS50gPOP/2vduAxtuTKnfoHPYmi9ypFauEwJzX9xpw0lfaKnNTl82nBJoSpaj
         m7Q5xoWJCEOxN0EBsXTtwEO/HcvdL/5MZJMhlJ0YJWiUdStOWZ+EqeJlN32uAviJT7jt
         Dp1Q==
X-Gm-Message-State: AFuF++kgdav0qxFln/PDO+j1IeJKHqDkF2NCAgb42X92sqR0DUE2AlJp
	JEU3SB7c4UjSxI3mcim+smli//ldgz0IiZMEuugDVlFgTtoKK5/MxZ8B80DUDQHwgqH41hbfB7o
	HRUjKnFGaTX8efwqP/6FvDrQ7zPxUAXF2PX98jJk=
X-Gm-Gg: AR+sD13KwX3miN8tVF7deGuHWjnQuRb0VdW0QIkx9NcgcDoWNSbbefvJSpn4ZZk3ZQb
	SPfajxum2HKHY+lt4ncvDptiV/ZnSsb5DXUAizR1udkDzDV/iEv2pATp7GkcPEvWQn4jv879AIB
	AJSOdVMpoDA/1QAzHflHI+X9ctVyMDW1LdTx0b7LNyXnH0tUKN0uP+6A2hWJV22Ermim4r/ZRC/
	dMpgHH9KcXGzW082CFIcDSxPHAi+kwtrF9iwHSkXeltotKzdsWMT2fnSTTxJcfhyzdw+UDvXqqg
	QwIRAwn2hrVkRuyZAwY7Ro+FkK/ZlgVkbVEpkMubC6Nn2xwUkOQWSnsxbWDZNXQyBbjBjSzQjkK
	Yvk8=
X-Received: by 2002:a05:690c:8d0f:b0:81e:7075:e2e3 with SMTP id
 00721157ae682-849f782c876mr79791007b3.35.1787559603924; Mon, 24 Aug 2026
 01:20:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAECVaXkeOMsosx0kPDxY5dK9VWkkS7pJADg-uL3X6DvWJrBEDA@mail.gmail.com>
 <CAECVaX=bD-aPD5b_6KT1AFxrrN49+DaDKWbHF5+Yj9CXQvtg5g@mail.gmail.com>
In-Reply-To: <CAECVaX=bD-aPD5b_6KT1AFxrrN49+DaDKWbHF5+Yj9CXQvtg5g@mail.gmail.com>
From: =?UTF-8?B?QUzEsE0gVEHFng==?= <alimtas12@gmail.com>
Date: Mon, 24 Aug 2026 11:19:51 +0300
X-Gm-Features: AcwNN1XQRrOPM4gGgF4c0Xa-tlGt2pxX-uJxQeZuYZt69sSe3bDsuuF-OXtA70o
Message-ID: <CAECVaXm6HRhnD8E_MrFnxgo4-_yMgeXz0JzcmmMMgZKkoE-omQ@mail.gmail.com>
Subject: Fwd: Proposal: gnu-efi-cli tool with .inf build support
To: linux-efi@vger.kernel.org, gnu@gnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

---------- Forwarded message ---------
G=C3=B6nderen: AL=C4=B0M TA=C5=9E <alimtas12@gmail.com>
Date: 15 A=C4=9Fu 2026 Cmt, 23:25
Subject: Fwd: Proposal: gnu-efi-cli tool with .inf build support
To: <linux-efi@vger.kernel.org>




---------- Forwarded message ---------
G=C3=B6nderen: AL=C4=B0M TA=C5=9E <alimtas12@gmail.com>
Date: 13 A=C4=9Fu 2026 Per, 14:10
Subject: Proposal: gnu-efi-cli tool with .inf build support
To: <gnu@gnu.org>


Hello GNU community,

I would like to propose a new tool for GNU-EFI development:
gnu-efi-cli. This tool aims to simplify and modularize the traditional
gcc =E2=86=92 ld =E2=86=92 objcopy build chain by introducing support for .=
inf files.

With gnu-efi-cli, developers can compile EFI applications using a
single command:

gnu-efi-cli efi.inf

An .inf file defines sources, architecture, output, and build options.
For example:

[Sources]
main.c
util.c

[Defines]
ARCH =3D x86_64
OUTPUT =3D MyApp.efi

[BuildOptions]
CFLAGS =3D -I/usr/include/efi -I/usr/include/efi/x86_64
-fno-stack-protector -fpic -fshort-wchar
LDFLAGS =3D -nostdlib -znocombreloc

The tool then automatically invokes gcc, ld, and objcopy to produce a
working EFI binary.

Advantages:

Easier compilation with a single command
Repeatable build process defined in INF files
Potential for future support of other toolchains (e.g., Clang)

If the community finds this idea useful, I plan to prepare a prototype
via a GitHub fork and submit a PR to GNU-EFI.

I look forward to your feedback and suggestions.

Best regards, ALIM
