/*import { useState } from "react";
import { Button } from "./ui/button";
import { LineChart, Line, XAxis, YAxis, ResponsiveContainer, Area, AreaChart, BarChart, Bar, PieChart, Pie, Cell } from "recharts";
import { Calendar, TrendingUp, Brain, Heart, Zap, Shield, CalendarDays, Plus } from "lucide-react";
import { Card, CardContent, CardHeader, CardTitle } from "./ui/card";
import { Badge } from "./ui/badge";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "./ui/tabs";

interface MoodTrackingScreenProps {
  onBackClick: () => void;
}

// Extended data for last 30 days
const moodData = [
  { day: "Dec 1", date: "2024-12-01", mood: 7, energy: 6, stress: 4, sleep: 7, gratitude: 8 },
  { day: "Dec 2", date: "2024-12-02", mood: 6, energy: 5, stress: 6, sleep: 6, gratitude: 6 },
  { day: "Dec 3", date: "2024-12-03", mood: 8, energy: 7, stress: 3, sleep: 8, gratitude: 9 },
  { day: "Dec 4", date: "2024-12-04", mood: 5, energy: 4, stress: 7, sleep: 5, gratitude: 5 },
  { day: "Dec 5", date: "2024-12-05", mood: 9, energy: 8, stress: 2, sleep: 9, gratitude: 9 },
  { day: "Dec 6", date: "2024-12-06", mood: 8, energy: 7, stress: 3, sleep: 8, gratitude: 8 },
  { day: "Dec 7", date: "2024-12-07", mood: 7, energy: 6, stress: 4, sleep: 7, gratitude: 7 },
  { day: "Dec 8", date: "2024-12-08", mood: 6, energy: 5, stress: 5, sleep: 6, gratitude: 6 },
  { day: "Dec 9", date: "2024-12-09", mood: 8, energy: 8, stress: 3, sleep: 8, gratitude: 8 },
  { day: "Dec 10", date: "2024-12-10", mood: 7, energy: 6, stress: 4, sleep: 7, gratitude: 7 },
  { day: "Dec 11", date: "2024-12-11", mood: 9, energy: 9, stress: 2, sleep: 9, gratitude: 9 },
  { day: "Dec 12", date: "2024-12-12", mood: 8, energy: 7, stress: 3, sleep: 8, gratitude: 8 },
  { day: "Dec 13", date: "2024-12-13", mood: 6, energy: 5, stress: 6, sleep: 6, gratitude: 6 },
  { day: "Dec 14", date: "2024-12-14", mood: 7, energy: 6, stress: 4, sleep: 7, gratitude: 7 }
];

const weeklyData = [
  { week: "Week 1", mood: 6.8, energy: 6.2, stress: 4.5, meditation: 3, exercises: 5 },
  { week: "Week 2", mood: 7.5, energy: 7.0, stress: 3.2, meditation: 5, exercises: 7 },
  { week: "Week 3", mood: 7.2, energy: 6.8, stress: 3.8, meditation: 4, exercises: 6 },
  { week: "Week 4", mood: 8.1, energy: 7.5, stress: 2.9, meditation: 6, exercises: 8 }
];

const emotionData = [
  { name: 'Happy', value: 35, color: '#10B981' },
  { name: 'Calm', value: 28, color: '#3B82F6' },
  { name: 'Anxious', value: 15, color: '#F59E0B' },
  { name: 'Sad', value: 12, color: '#EF4444' },
  { name: 'Excited', value: 10, color: '#8B5CF6' }
];

const insights = [
  {
    title: "Mood Pattern",
    description: "Your mood peaks on Friday and dips mid-week",
    suggestion: "Consider scheduling self-care activities on Wednesday",
    trend: "improving",
    icon: TrendingUp
  },
  {
    title: "Stress Triggers",
    description: "Stress levels highest on Tuesday and Thursday",
    suggestion: "Try meditation before challenging workdays",
    trend: "stable",
    icon: Shield
  },
  {
    title: "Energy Levels",
    description: "Energy follows mood patterns closely",
    suggestion: "Maintain consistent sleep schedule for stable energy",
    trend: "improving",
    icon: Zap
  },
  {
    title: "Sleep Quality",
    description: "Better sleep correlates with improved mood",
    suggestion: "Aim for 8 hours of sleep consistently",
    trend: "improving",
    icon: Brain
  }
];

const achievements = [
  { title: "7-Day Streak", description: "Logged mood for 7 consecutive days", unlocked: true },
  { title: "Stress Warrior", description: "Managed stress levels below 4 for a week", unlocked: true },
  { title: "Mindful Month", description: "30 days of mood tracking", unlocked: false },
  { title: "Mood Master", description: "Maintained positive mood for 14 days", unlocked: false }
];

export default function MoodTrackingScreen({ onBackClick }: MoodTrackingScreenProps) {
  const [selectedView, setSelectedView] = useState<'daily' | 'weekly' | 'insights' | 'calendar'>('daily');
  const [selectedMetric, setSelectedMetric] = useState<'mood' | 'energy' | 'stress' | 'sleep' | 'gratitude'>('mood');

  const currentData = moodData.slice(-7).map(item => ({
    ...item,
    value: item[selectedMetric]
  }));

  const avgMood = Math.round(moodData.reduce((sum, item) => sum + item.mood, 0) / moodData.length);
  const avgEnergy = Math.round(moodData.reduce((sum, item) => sum + item.energy, 0) / moodData.length);
  const avgStress = Math.round(moodData.reduce((sum, item) => sum + item.stress, 0) / moodData.length);
  const avgSleep = Math.round(moodData.reduce((sum, item) => sum + item.sleep, 0) / moodData.length);

  const getMetricColor = (metric: string) => {
    switch (metric) {
      case 'mood': return '#8B5CF6';
      case 'energy': return '#06B6D4';
      case 'stress': return '#EF4444';
      case 'sleep': return '#10B981';
      case 'gratitude': return '#F59E0B';
      default: return '#8B5CF6';
    }
  };

  const getTrendColor = (trend: string) => {
    switch (trend) {
      case 'improving': return 'text-green-400';
      case 'declining': return 'text-red-400';
      default: return 'text-yellow-400';
    }
  };

  return (
    <div className="bg-[#050e17] h-[100dvh] max-h-[800px] w-full overflow-clip relative rounded-[20px]">
      <div className="flex items-center justify-between p-4 pt-16 relative z-10">
        <Button 
          variant="ghost" 
          size="icon"
          onClick={onBackClick}
          className="text-white hover:bg-white/10 transition-all duration-300"
        >
          ←
        </Button>
        <h1 className="text-white text-lg font-semibold">Mood Insights</h1>
        <Button
          variant="ghost"
          size="icon" 
          className="text-white hover:bg-white/10"
        >
          <Plus className="w-5 h-5" />
        </Button>
      </div>

      <div className="px-4 pb-4 h-[calc(100%-80px)] overflow-hidden">
        <Tabs value={selectedView} onValueChange={(value) => setSelectedView(value as any)} className="h-full flex flex-col">
          <TabsList className="w-full bg-white/5 mb-4 grid grid-cols-4 h-12">
            <TabsTrigger value="daily" className="text-white/60 data-[state=active]:text-white data-[state=active]:bg-white/10 text-sm">
              Daily
            </TabsTrigger>
            <TabsTrigger value="weekly" className="text-white/60 data-[state=active]:text-white data-[state=active]:bg-white/10 text-sm">
              Weekly
            </TabsTrigger>
            <TabsTrigger value="insights" className="text-white/60 data-[state=active]:text-white data-[state=active]:bg-white/10 text-sm">
              Insights
            </TabsTrigger>
            <TabsTrigger value="calendar" className="text-white/60 data-[state=active]:text-white data-[state=active]:bg-white/10 text-sm">
              Calendar
            </TabsTrigger>
          </TabsList>

          <TabsContent value="daily" className="mt-0 h-full overflow-y-auto">
            <div className="flex gap-2 mb-4 overflow-x-auto">
              {(['mood', 'energy', 'stress', 'sleep', 'gratitude'] as const).map((metric) => (
                <Button
                  key={metric}
                  variant={selectedMetric === metric ? "default" : "ghost"}
                  size="sm"
                  onClick={() => setSelectedMetric(metric)}
                  className={`
                    capitalize shrink-0 text-xs
                    ${selectedMetric === metric 
                      ? 'bg-white/20 text-white hover:bg-white/30' 
                      : 'text-white/70 hover:bg-white/10 hover:text-white'
                    }
                  `}
                >
                  {metric}
                </Button>
              ))}
            </div>

            <Card className="bg-white/5 border-white/10 mb-4">
              <CardHeader className="pb-2">
                <CardTitle className="text-white text-sm capitalize">
                  {selectedMetric} - Last 7 Days
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="h-24">
                  <ResponsiveContainer width="100%" height="100%">
                    <AreaChart data={currentData}>
                      <defs>
                        <linearGradient id={`gradient-${selectedMetric}`} x1="0" y1="0" x2="0" y2="1">
                          <stop offset="5%" stopColor={getMetricColor(selectedMetric)} stopOpacity={0.3}/>
                          <stop offset="95%" stopColor={getMetricColor(selectedMetric)} stopOpacity={0}/>
                        </linearGradient>
                      </defs>
                      <XAxis 
                        dataKey="day" 
                        axisLine={false}
                        tickLine={false}
                        tick={{ fill: 'white', fontSize: 10 }}
                      />
                      <YAxis hide />
                      <Area
                        type="monotone"
                        dataKey="value"
                        stroke={getMetricColor(selectedMetric)}
                        strokeWidth={2}
                        fill={`url(#gradient-${selectedMetric})`}
                      />
                    </AreaChart>
                  </ResponsiveContainer>
                </div>
              </CardContent>
            </Card>

            <div className="grid grid-cols-4 gap-2 mb-4">
              <Card className="bg-white/5 border-white/10 p-2 text-center">
                <div className="text-purple-400 text-sm font-semibold">{avgMood}</div>
                <div className="text-white/60 text-xs">Mood</div>
              </Card>
              <Card className="bg-white/5 border-white/10 p-2 text-center">
                <div className="text-cyan-400 text-sm font-semibold">{avgEnergy}</div>
                <div className="text-white/60 text-xs">Energy</div>
              </Card>
              <Card className="bg-white/5 border-white/10 p-2 text-center">
                <div className="text-red-400 text-sm font-semibold">{avgStress}</div>
                <div className="text-white/60 text-xs">Stress</div>
              </Card>
              <Card className="bg-white/5 border-white/10 p-2 text-center">
                <div className="text-green-400 text-sm font-semibold">{avgSleep}</div>
                <div className="text-white/60 text-xs">Sleep</div>
              </Card>
            </div>

            <Card className="bg-white/5 border-white/10">
              <CardHeader className="pb-2">
                <CardTitle className="text-white text-sm">Emotion Distribution</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="h-20">
                  <ResponsiveContainer width="100%" height="100%">
                    <PieChart>
                      <Pie
                        data={emotionData}
                        cx="50%"
                        cy="50%"
                        innerRadius={20}
                        outerRadius={35}
                        dataKey="value"
                      >
                        {emotionData.map((entry, index) => (
                          <Cell key={`cell-${index}`} fill={entry.color} />
                        ))}
                      </Pie>
                    </PieChart>
                  </ResponsiveContainer>
                </div>
                <div className="flex justify-center gap-2 mt-2">
                  {emotionData.slice(0, 3).map((emotion) => (
                    <div key={emotion.name} className="flex items-center gap-1">
                      <div className="w-2 h-2 rounded-full" style={{ backgroundColor: emotion.color }} />
                      <span className="text-white/70 text-xs">{emotion.name}</span>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </TabsContent>

          <TabsContent value="weekly" className="mt-0 h-full overflow-y-auto">
            <Card className="bg-white/5 border-white/10 mb-4">
              <CardHeader className="pb-2">
                <CardTitle className="text-white text-sm">Weekly Trends</CardTitle>
              </CardHeader>
              <CardContent>
                <div className="h-32">
                  <ResponsiveContainer width="100%" height="100%">
                    <BarChart data={weeklyData}>
                      <XAxis dataKey="week" tick={{ fill: 'white', fontSize: 10 }} />
                      <YAxis hide />
                      <Bar dataKey="mood" fill="#8B5CF6" />
                      <Bar dataKey="energy" fill="#06B6D4" />
                    </BarChart>
                  </ResponsiveContainer>
                </div>
              </CardContent>
            </Card>

            <div className="space-y-2">
              <h3 className="text-white text-sm font-medium">Achievements</h3>
              {achievements.map((achievement, index) => (
                <Card key={index} className={`bg-white/5 border-white/10 p-3 ${achievement.unlocked ? 'border-green-400/50' : ''}`}>
                  <div className="flex items-center justify-between">
                    <div>
                      <div className="text-white text-sm font-medium">{achievement.title}</div>
                      <div className="text-white/60 text-xs">{achievement.description}</div>
                    </div>
                    <Badge variant={achievement.unlocked ? "default" : "outline"} className={achievement.unlocked ? "bg-green-400/20 text-green-400" : "text-white/60"}>
                      {achievement.unlocked ? "Unlocked" : "Locked"}
                    </Badge>
                  </div>
                </Card>
              ))}
            </div>
          </TabsContent>

          <TabsContent value="insights" className="mt-0 h-full overflow-y-auto">
            <div className="space-y-3">
              {insights.map((insight, index) => {
                const Icon = insight.icon;
                return (
                  <Card key={index} className="bg-white/5 border-white/10 p-3">
                    <div className="flex items-start gap-3">
                      <div className="p-2 bg-white/10 rounded-lg">
                        <Icon className="w-4 h-4 text-white" />
                      </div>
                      <div className="flex-1">
                        <div className="flex items-center gap-2 mb-1">
                          <h4 className="text-white text-sm font-medium">{insight.title}</h4>
                          <Badge variant="outline" className={`text-xs ${getTrendColor(insight.trend)}`}>
                            {insight.trend}
                          </Badge>
                        </div>
                        <p className="text-white/70 text-xs mb-2">{insight.description}</p>
                        <p className="text-cyan-400 text-xs">{insight.suggestion}</p>
                      </div>
                    </div>
                  </Card>
                );
              })}
            </div>
          </TabsContent>

          <TabsContent value="calendar" className="mt-0 h-full overflow-y-auto">
            <Card className="bg-white/5 border-white/10">
              <CardHeader className="pb-2">
                <CardTitle className="text-white text-sm flex items-center gap-2">
                  <CalendarDays className="w-4 h-4" />
                  December 2024
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="grid grid-cols-7 gap-1 text-center">
                  {['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) => (
                    <div key={day} className="text-white/60 text-xs font-medium p-1">{day}</div>
                  ))}
                  {Array.from({ length: 31 }, (_, i) => i + 1).map((day) => {
                    const dayData = moodData.find(d => new Date(d.date).getDate() === day);
                    const moodColor = dayData ? 
                      (dayData.mood >= 8 ? 'bg-green-400' : 
                       dayData.mood >= 6 ? 'bg-yellow-400' : 
                       dayData.mood >= 4 ? 'bg-orange-400' : 'bg-red-400') 
                      : 'bg-white/10';
                    
                    return (
                      <div key={day} className={`w-6 h-6 ${moodColor} rounded text-xs flex items-center justify-center text-white font-medium`}>
                        {day}
                      </div>
                    );
                  })}
                </div>
                <div className="flex justify-center gap-2 mt-3 text-xs">
                  <div className="flex items-center gap-1">
                    <div className="w-2 h-2 bg-green-400 rounded" />
                    <span className="text-white/70">Great</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <div className="w-2 h-2 bg-yellow-400 rounded" />
                    <span className="text-white/70">Good</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <div className="w-2 h-2 bg-orange-400 rounded" />
                    <span className="text-white/70">Okay</span>
                  </div>
                  <div className="flex items-center gap-1">
                    <div className="w-2 h-2 bg-red-400 rounded" />
                    <span className="text-white/70">Poor</span>
                  </div>
                </div>
              </CardContent>
            </Card>
          </TabsContent>
        </Tabs>
      </div>
    </div>
  );
}


import { useState, useEffect } from "react";
import svgPaths from "../imports/svg-eq3g8l9khy";
import imgEllipse214 from "figma:asset/07d3d24fa8502ec7bc065cfca0bbbe284a9181ee.png";
import imgAsset31 from "figma:asset/caec6c3f78f7805c486c979f08e0ec7b3f5f8f7f.png";
import { MessageCircle, Send, MoreVertical } from "lucide-react";
import { Button } from "./ui/button";
import { ScrollArea } from "./ui/scroll-area";

interface VoiceChatScreenProps {
  onBackClick: () => void;
}

interface Message {
  id: string;
  text: string;
  isUser: boolean;
  timestamp: Date;
  type?: 'text' | 'voice';
}

const initialMessages: Message[] = [
  {
    id: '1',
    text: "Hello! I'm your personal AI companion. I'm here to listen and support you through any challenges you're facing. How are you feeling today?",
    isUser: false,
    timestamp: new Date(Date.now() - 300000),
    type: 'text'
  },
  {
    id: '2', 
    text: "I'm having anxiety about my career, can you help me dealing with it?",
    isUser: true,
    timestamp: new Date(Date.now() - 180000),
    type: 'voice'
  },
  {
    id: '3',
    text: "I understand that career anxiety can feel overwhelming. It's completely normal to feel uncertain about your professional path. Let's explore this together - what specific aspects of your career are causing you the most concern right now?",
    isUser: false,
    timestamp: new Date(Date.now() - 120000),
    type: 'text'
  }
];

function Group18309() {
  return (
    <div className="absolute contents top-[228px] translate-x-[-50%]" style={{ left: "calc(50% - 353px)" }}>
      <div className="absolute flex h-[95.125px] items-center justify-center top-[228px] w-[27.547px]" style={{ left: "calc(50% - 368px)" }}>
        <div className="flex-none rotate-[270deg]">
          <div className="font-['Oxanium:SemiBold',_sans-serif] font-semibold leading-[0] relative text-[24px] text-nowrap text-white">
            <p className="leading-[normal] whitespace-pre">{`Calm AI `}</p>
          </div>
        </div>
      </div>
    </div>
  );
}

function Group18311({ onBackClick }: { onBackClick: () => void }) {
  return (
    <div className="absolute contents left-[38px] top-[228px]">
      <button 
        onClick={onBackClick}
        className="absolute flex h-[18px] items-center justify-center left-[46px] top-[329px] w-[14.156px] cursor-pointer hover:opacity-80 transition-opacity"
      >
        <div className="flex-none rotate-[90deg]">
          <div className="h-[14.178px] relative w-[18px]" data-name="Arrow">
            <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 18 15">
              <path d={svgPaths.p332b9580} fill="var(--fill-0, white)" id="Arrow" />
            </svg>
          </div>
        </div>
      </button>
      <Group18309 />
    </div>
  );
}

function PhStarFour() {
  return (
    <div className="relative size-[16px]" data-name="ph:star-four">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 16 16">
        <g id="ph:star-four">
          <path d={svgPaths.p15a56800} fill="var(--fill-0, white)" id="Vector" />
        </g>
      </svg>
    </div>
  );
}

function PhStarFour1() {
  return (
    <div className="relative size-[8px]" data-name="ph:star-four">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 8 8">
        <g clipPath="url(#clip0_3_175)" id="ph:star-four">
          <path d={svgPaths.p168f9100} fill="var(--fill-0, white)" id="Vector" />
        </g>
        <defs>
          <clipPath id="clip0_3_175">
            <rect fill="white" height="8" width="8" />
          </clipPath>
        </defs>
      </svg>
    </div>
  );
}

function Group18312({ onBackClick }: { onBackClick: () => void }) {
  return (
    <div className="absolute contents left-[31px] top-[26px]">
      <Group18311 onBackClick={onBackClick} />
      <div className="absolute flex h-[44px] items-center justify-center left-[31px] top-[26px] w-[44px]">
        <div className="flex-none rotate-[270deg]">
          <div className="relative size-[44px]">
            <img alt="" className="block max-w-none size-full" height="44" src={imgEllipse214} width="44" />
          </div>
        </div>
      </div>
      <div className="absolute flex h-[16px] items-center justify-center left-[44px] top-[207px] w-[16px]">
        <div className="flex-none rotate-[270deg]">
          <PhStarFour />
        </div>
      </div>
      <div className="absolute flex h-[8px] items-center justify-center left-[42px] top-[205px] w-[8px]">
        <div className="flex-none rotate-[270deg]">
          <PhStarFour1 />
        </div>
      </div>
    </div>
  );
}

function Keyboard101() {
  return (
    <div className="relative size-[24px]" data-name="keyboard.10 1">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="keyboard.10 1">
          <path d={svgPaths.p31563900} fill="var(--fill-0, white)" id="Vector" />
          <path d={svgPaths.p192d0000} fill="var(--fill-0, white)" id="Vector_2" />
          <path d={svgPaths.p27dbfe00} fill="var(--fill-0, white)" id="Vector_3" />
          <path d={svgPaths.pfe8f840} fill="var(--fill-0, white)" id="Vector_4" />
          <path d={svgPaths.pec43400} fill="var(--fill-0, white)" id="Vector_5" />
        </g>
      </svg>
    </div>
  );
}

function FiRrCrossSmall11({ onClick }: { onClick: () => void }) {
  return (
    <button 
      onClick={onClick}
      className="relative size-[24px] cursor-pointer hover:opacity-80 transition-opacity" 
      data-name="fi-rr-cross-small.1 1"
    >
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 24 24">
        <g id="fi-rr-cross-small.1 1">
          <path d={svgPaths.p2913ed00} fill="var(--fill-0, white)" id="Vector" />
        </g>
      </svg>
    </button>
  );
}

function Group18326({ userMessage }: { userMessage: string }) {
  return (
    <div className="absolute contents left-[459px] top-[28px]">
      <div className="absolute flex h-[320px] items-center justify-center left-[507px] top-[28px] translate-x-[-50%] w-[82.656px]">
        <div className="flex-none rotate-[270deg]">
          <div className="bg-clip-text bg-gradient-to-b font-['Helvetica:Regular',_sans-serif] from-[#ffffff] from-[14.583%] leading-[0] not-italic relative text-[24px] text-center to-[101.56%] to-[rgba(255,255,255,0.3)] via-[60.645%] via-[rgba(255,255,255,0.6)] w-[320px]" style={{ WebkitTextFillColor: "transparent" }}>
            <p className="leading-[normal]">{userMessage}</p>
          </div>
        </div>
      </div>
    </div>
  );
}

function Microphone() {
  return (
    <div className="absolute inset-[4.17%_12.5%_6.25%_12.5%]" data-name="microphone">
      <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 29 35">
        <g id="microphone">
          <path d={svgPaths.p10a6fab2} fill="var(--fill-0, #112A4C)" id="shape" />
        </g>
      </svg>
    </div>
  );
}

function BoldOutline() {
  return (
    <div className="absolute contents inset-[4.17%_12.5%_6.25%_12.5%]" data-name="Bold-Outline">
      <Microphone />
    </div>
  );
}

function Microphone1({ isRecording, onClick }: { isRecording: boolean; onClick: () => void }) {
  return (
    <button
      onClick={onClick}
      className={`overflow-clip relative size-[38px] cursor-pointer transition-transform ${isRecording ? 'scale-110' : 'hover:scale-105'}`}
      data-name="microphone 1"
    >
      <BoldOutline />
    </button>
  );
}

function Group3({ isRecording, onMicClick }: { isRecording: boolean; onMicClick: () => void }) {
  return (
    <div className="absolute contents left-[614px] top-[88px]">
      <div className={`absolute flex h-[96px] items-center justify-center left-[665px] top-[139px] w-[96px] ${isRecording ? 'animate-pulse' : ''}`}>
        <div className="flex-none rotate-[270deg]">
          <div className="relative size-[96px]">
            <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 96 96">
              <g id="Ellipse 80">
                <circle cx="48" cy="48" fill="url(#paint0_radial_3_182)" r="48" />
                <circle cx="48" cy="48" r="47.5" stroke="var(--stroke-0, white)" strokeOpacity="0.6" />
              </g>
              <defs>
                <radialGradient cx="0" cy="0" gradientTransform="translate(48 48) rotate(90) scale(48)" gradientUnits="userSpaceOnUse" id="paint0_radial_3_182" r="1">
                  <stop stopColor="white" />
                  <stop offset="0.509" stopColor="#95ACCB" />
                  <stop offset="1" stopColor="#112A4C" />
                </radialGradient>
              </defs>
            </svg>
          </div>
        </div>
      </div>
      <div className={`absolute flex h-[118px] items-center justify-center left-[654px] top-[128px] w-[118px] ${isRecording ? 'opacity-80' : ''}`}>
        <div className="flex-none rotate-[270deg]">
          <div className="relative size-[118px]">
            <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 118 118">
              <circle cx="59" cy="59" id="Ellipse 81" r="58.5" stroke="var(--stroke-0, white)" strokeOpacity="0.4" />
            </svg>
          </div>
        </div>
      </div>
      <div className={`absolute flex h-[154px] items-center justify-center left-[636px] top-[110px] w-[154px] ${isRecording ? 'opacity-60' : ''}`}>
        <div className="flex-none rotate-[270deg]">
          <div className="relative size-[154px]">
            <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 154 154">
              <circle cx="77" cy="77" id="Ellipse 82" opacity="0.25" r="76.5" stroke="var(--stroke-0, white)" />
            </svg>
          </div>
        </div>
      </div>
      <div className={`absolute flex h-[198px] items-center justify-center left-[614px] top-[88px] w-[198px] ${isRecording ? 'opacity-40' : ''}`}>
        <div className="flex-none rotate-[270deg]">
          <div className="relative size-[198px]">
            <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 198 198">
              <circle cx="99" cy="99" id="Ellipse 83" opacity="0.1" r="98.5" stroke="var(--stroke-0, white)" />
            </svg>
          </div>
        </div>
      </div>
      <div className="absolute flex h-[38px] items-center justify-center left-[694px] top-[168px] w-[38px]">
        <div className="flex-none rotate-[270deg]">
          <Microphone1 isRecording={isRecording} onClick={onMicClick} />
        </div>
      </div>
    </div>
  );
}

function Group18325({ isRecording, onMicClick }: { isRecording: boolean; onMicClick: () => void }) {
  return (
    <div className="absolute contents left-[614px] top-[88px]">
      <Group3 isRecording={isRecording} onMicClick={onMicClick} />
    </div>
  );
}

export default function VoiceChatScreen({ onBackClick }: VoiceChatScreenProps) {
  const [isRecording, setIsRecording] = useState(false);
  const [messages, setMessages] = useState<Message[]>(initialMessages);
  const [statusText, setStatusText] = useState("I'm listening");
  const [showConversation, setShowConversation] = useState(false);

  const aiResponses = [
    "That sounds really challenging. Career anxiety often stems from uncertainty about the future. What specific aspects worry you most?",
    "It's completely natural to feel this way. Many people experience career-related stress. Have you considered what success looks like to you personally?",
    "I hear the concern in your voice. Sometimes breaking down our worries into smaller, manageable pieces can help. What's one small step you could take today?",
    "Your feelings are valid. Career transitions and decisions can be overwhelming. What support systems do you have around you?",
    "Thank you for sharing that with me. It takes courage to acknowledge these feelings. What aspects of your career bring you joy or satisfaction?"
  ];

  const handleMicClick = () => {
    if (!isRecording) {
      setIsRecording(true);
      setStatusText("Recording...");
      
      // Simulate recording
      setTimeout(() => {
        setIsRecording(false);
        setStatusText("Processing...");
        
        // Add user message
        const userMessage: Message = {
          id: Date.now().toString(),
          text: "I feel like I'm not making progress in my career and everyone around me seems to be doing better.",
          isUser: true,
          timestamp: new Date(),
          type: 'voice'
        };
        
        setMessages(prev => [...prev, userMessage]);
        
        // Simulate AI processing and response
        setTimeout(() => {
          const aiResponse: Message = {
            id: (Date.now() + 1).toString(),
            text: aiResponses[Math.floor(Math.random() * aiResponses.length)],
            isUser: false,
            timestamp: new Date(),
            type: 'text'
          };
          
          setMessages(prev => [...prev, aiResponse]);
          setStatusText("I'm listening");
        }, 2000);
      }, 3000);
    }
  };

  const formatTime = (date: Date) => {
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
  };

  return (
    <div className="bg-[#050e17] h-[100dvh] max-h-[800px] w-full overflow-clip relative rounded-[20px]" data-name="Ai voice chat">
      {!showConversation ? (
        <>
          <div className="absolute flex inset-[83.2%_9.24%_4%_84.85%] items-center justify-center">
            <div className="flex-none rotate-[270deg] size-[48px]">
              <div className="relative size-full">
                <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 48 48">
                  <circle cx="24" cy="24" fill="var(--fill-0, #112A4C)" id="Ellipse 84" r="24" />
                </svg>
              </div>
            </div>
          </div>
          <div className="absolute flex inset-[3.73%_9.24%_83.47%_84.85%] items-center justify-center">
            <div className="flex-none rotate-[270deg] size-[48px]">
              <div className="relative size-full">
                <svg className="block size-full" fill="none" preserveAspectRatio="none" viewBox="0 0 48 48">
                  <circle cx="24" cy="24" fill="var(--fill-0, #112A4C)" id="Ellipse 84" r="24" />
                </svg>
              </div>
            </div>
          </div>
          <div className="absolute top-[140px] left-[20px] right-[20px] text-center">
            <div className="font-['Helvetica:Regular',_sans-serif] text-2xl text-[rgba(255,255,255,0.86)] tracking-[0.48px]">
              <p className="leading-[1.2]">{statusText}</p>
            </div>
          </div>
          <Group18312 onBackClick={onBackClick} />
          
          <div className="absolute top-[60px] left-[20px] right-[20px] flex items-center justify-between z-10">
            <Button
              variant="ghost"
              size="icon"
              onClick={onBackClick}
              className="text-white hover:bg-white/10 transition-all duration-300"
            >
              ←
            </Button>
            <h1 className="text-white font-['Oxanium:SemiBold',_sans-serif] text-xl">Calm AI</h1>
            <Button
              variant="ghost"
              size="icon"
              onClick={() => setShowConversation(true)}
              className="text-white hover:bg-white/10 transition-all duration-300"
            >
              <MessageCircle className="w-5 h-5" />
            </Button>
          </div>
          
          <div className="absolute flex h-[24px] items-center justify-center left-[701px] top-[324px] w-[24px]">
            <div className="flex-none rotate-[270deg]">
              <Keyboard101 />
            </div>
          </div>
          <div className="absolute top-[200px] left-1/2 transform -translate-x-1/2">
            <div className="w-48 h-48 relative">
              <img 
                alt="AI Avatar" 
                className="w-full h-full object-cover rounded-full opacity-80" 
                src={imgAsset31} 
              />
            </div>
          </div>

          <div className="absolute bottom-[120px] left-1/2 transform -translate-x-1/2">
            <Group18325 isRecording={isRecording} onMicClick={handleMicClick} />
          </div>
        </>
      ) : (
        <div className="h-full flex flex-col">
          <div className="flex items-center justify-between p-4 pt-16 border-b border-white/10">
            <div className="flex items-center gap-3">
              <Button
                variant="ghost"
                size="icon"
                onClick={() => setShowConversation(false)}
                className="text-white hover:bg-white/10"
              >
                ←
              </Button>
              <div className="flex items-center gap-2">
                <img src={imgEllipse214} alt="" className="w-8 h-8 rounded-full" />
                <div>
                  <h2 className="text-white font-medium">Calm AI</h2>
                  <p className="text-white/60 text-sm">Always here to listen</p>
                </div>
              </div>
            </div>
            <Button
              variant="ghost"
              size="icon"
              className="text-white hover:bg-white/10"
            >
              <MoreVertical className="w-4 h-4" />
            </Button>
          </div>

          <ScrollArea className="flex-1 p-4">
            <div className="space-y-4">
              {messages.map((message) => (
                <div
                  key={message.id}
                  className={`flex ${message.isUser ? 'justify-end' : 'justify-start'}`}
                >
                  <div className={`max-w-[70%] ${message.isUser ? 'order-2' : 'order-1'}`}>
                    <div
                      className={`rounded-2xl p-3 ${
                        message.isUser
                          ? 'bg-blue-600 text-white'
                          : 'bg-white/10 text-white'
                      }`}
                    >
                      <p className="text-sm">{message.text}</p>
                      {message.type === 'voice' && (
                        <div className="flex items-center gap-1 mt-1 opacity-70">
                          <div className="w-2 h-2 bg-current rounded-full" />
                          <span className="text-xs">Voice message</span>
                        </div>
                      )}
                    </div>
                    <p className="text-xs text-white/50 mt-1 px-3">
                      {formatTime(message.timestamp)}
                    </p>
                  </div>
                </div>
              ))}
            </div>
          </ScrollArea>

          <div className="p-4 border-t border-white/10">
            <div className="flex items-center gap-3">
              <Button
                variant="ghost"
                size="icon"
                onClick={handleMicClick}
                className={`text-white hover:bg-white/10 transition-all duration-300 ${
                  isRecording ? 'bg-red-500/20 text-red-400 animate-pulse' : ''
                }`}
              >
                <Microphone1 isRecording={isRecording} onClick={() => {}} />
              </Button>
              <div className="flex-1 bg-white/10 rounded-2xl px-4 py-2">
                <input
                  type="text"
                  placeholder="Type a message or use voice..."
                  className="w-full bg-transparent text-white placeholder-white/50 text-sm outline-none"
                />
              </div>
              <Button
                variant="ghost"
                size="icon"
                className="text-white hover:bg-white/10"
              >
                <Send className="w-4 h-4" />
              </Button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
*/